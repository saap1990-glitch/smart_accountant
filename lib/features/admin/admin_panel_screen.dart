import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/subscription/anti_tamper_service.dart';
import '../../core/services/targets/target_service.dart';
import '../../core/services/admin/owner_auth_service.dart';

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

  final _codeCtrl = TextEditingController();
  bool _authenticated = false;
  String? _generatedCode;
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

  void _login() {
    if (_codeCtrl.text == 'smart2026admin' || _codeCtrl.text == 'admin') {
      setState(() { _authenticated = true; _error = null; });
    } else {
      setState(() => _error = 'رمز غير صحيح');
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.admin_panel_settings, size: 70, color: Colors.purple),
              const SizedBox(height: 16),
              const Text('دخول المالك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: _codeCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'رمز المالك', hintText: 'admin', border: OutlineInputBorder())),
              if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _login, child: const Text('دخول')),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المالك'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => setState(() => _authenticated = false))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🔑 توليد رموز التفعيل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () => setState(() => _generatedCode = SubscriptionService.generateCode(SubscriptionType.semiAnnual, 'admin')), child: const Text('نصف سنوي'))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () => setState(() => _generatedCode = SubscriptionService.generateCode(SubscriptionType.annual, 'admin')), child: const Text('سنوي'))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), onPressed: () => setState(() => _generatedCode = SubscriptionService.generateCode(SubscriptionType.lifetime, 'admin')), child: const Text('مدى الحياة'))),
          ]),
          if (_generatedCode != null) ...[
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)), child: Text(_generatedCode!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2))),
          ],
        ]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('🛡️ الأمان: ${_tampered ? '⚠️ تلاعب مكتشف' : '✅ آمن'}', style: TextStyle(fontWeight: FontWeight.bold, color: _tampered ? Colors.red : Colors.green)),
          if (_tampered) ElevatedButton(onPressed: () async { await _antiTamper.resetTamperFlag(); setState(() => _tampered = false); }, child: const Text('إعادة تعيين')),
        ]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('📊 مندوبين: ${_targets.allTargets.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('الهدف الشهري: ${_targets.overallTarget.monthlyTarget.toStringAsFixed(0)} ريال'),
        ]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('👑 الاشتراك: ${_sub.isActive ? 'نشط (${_sub.daysLeft} يوم)' : 'منتهي'}', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('النوع: ${_sub.type.name}'),
        ]))),
      ]),
    );
  }
}
