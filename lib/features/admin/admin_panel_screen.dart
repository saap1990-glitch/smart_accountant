import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/subscription/anti_tamper_service.dart';
import '../../core/services/admin/owner_auth_service.dart';
import '../../core/services/targets/target_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _sub = GetIt.I<SubscriptionService>();
  final _antiTamper = GetIt.I<AntiTamperService>();
  final _targets = GetIt.I<TargetService>();
  final _ownerAuth = GetIt.I<OwnerAuthService>();
  final _firestore = FirebaseFirestore.instance;

  final _codeCtrl = TextEditingController();
  final _notifTitleCtrl = TextEditingController();
  final _notifMsgCtrl = TextEditingController();

  bool _authenticated = false;
  bool _tampered = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkTamper();
  }

  Future<void> _checkTamper() async {
    final tampered = await _antiTamper.wasTampered();
    if (mounted) setState(() => _tampered = tampered);
  }

  Future<void> _login() async {
    if (await _ownerAuth.verifyOwner(_codeCtrl.text)) {
      setState(() => _authenticated = true);
    } else {
      setState(() => _error = 'رمز غير صحيح');
    }
  }

  Future<void> _generateCode(String type, int days) async {
    final prefix = type == 'semi_annual'
        ? 'SEMI'
        : type == 'annual'
        ? 'ANNUAL'
        : 'LIFE';
    final code =
        '$prefix-${DateTime.now().millisecondsSinceEpoch.hashCode.abs().toString().substring(0, 8)}';
    final start = DateTime.now();
    final expiry = start.add(Duration(days: days));

    await _firestore.collection('subscriptions').add({
      'code': code,
      'type': type,
      'start_date': start.toIso8601String(),
      'expiry_date': expiry.toIso8601String(),
      'is_active': true,
      'revoked': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم توليد الرمز: $code')));
    }
  }

  Future<void> _revokeCode(String code) async {
    final snapshot = await _firestore
        .collection('subscriptions')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update({'revoked': true});
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إبطال الرمز $code')));
      }
    }
  }

  Future<void> _sendNotification() async {
    if (_notifTitleCtrl.text.isEmpty || _notifMsgCtrl.text.isEmpty) return;
    await _firestore.collection('notifications').add({
      'title': _notifTitleCtrl.text,
      'message': _notifMsgCtrl.text,
      'created_at': DateTime.now().toIso8601String(),
    });
    _notifTitleCtrl.clear();
    _notifMsgCtrl.clear();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال الإشعار')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('لوحة تحكم المالك')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 70,
                  color: Colors.purple,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'رمز المالك',
                    hintText: 'admin',
                  ),
                ),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _login, child: const Text('دخول')),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تحكم المالك'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => setState(() => _authenticated = false),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'نظرة عامة'),
              Tab(text: 'الرموز'),
              Tab(text: 'الإشعارات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_overviewTab(), _codesTab(), _notificationsTab()],
        ),
      ),
    );
  }

  Widget _overviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 ملخص',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _statRow('حالة الاشتراك', _sub.isActive ? 'نشط' : 'منتهي'),
                _statRow('النوع', _sub.type.name),
                _statRow('أيام متبقية', '${_sub.daysLeft}'),
                _statRow('حالة الحماية', _tampered ? '⚠️ تلاعب' : '✅ آمن'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _codesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('subscriptions')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _generateCode('semi_annual', 180),
                  child: const Text('نصف سنوي'),
                ),
                ElevatedButton(
                  onPressed: () => _generateCode('annual', 365),
                  child: const Text('سنوي'),
                ),
                ElevatedButton(
                  onPressed: () => _generateCode('lifetime', 36500),
                  child: const Text('مدى الحياة'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (docs.isEmpty)
              const Center(child: Text('لا توجد رموز بعد'))
            else
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final code = data['code'] ?? '';
                final revoked = data['revoked'] == true;
                return Card(
                  child: ListTile(
                    title: Text(
                      code,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    subtitle: Text('${data['type']} - ${data['expiry_date']}'),
                    trailing: revoked
                        ? const Icon(Icons.block, color: Colors.red)
                        : IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _revokeCode(code),
                          ),
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }

  Widget _notificationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إرسال إشعار',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notifTitleCtrl,
                  decoration: const InputDecoration(labelText: 'العنوان'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notifMsgCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'الرسالة'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _sendNotification,
                  child: const Text('إرسال'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('notifications')
              .orderBy('created_at', descending: true)
              .limit(20)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final docs = snapshot.data!.docs;
            return Column(
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(data['title'] ?? ''),
                    subtitle: Text(data['message'] ?? ''),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _notifTitleCtrl.dispose();
    _notifMsgCtrl.dispose();
    super.dispose();
  }
}
