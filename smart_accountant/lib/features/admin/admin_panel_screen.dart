import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/subscription/anti_tamper_service.dart';
import '../../core/services/targets/target_service.dart';

class AdminPanelScreen extends StatefulWidget {
  final String adminSecret;
  const AdminPanelScreen({super.key, this.adminSecret = 'admin123'});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _sub = GetIt.I<SubscriptionService>();
  final _antiTamper = GetIt.I<AntiTamperService>();
  final _targets = GetIt.I<TargetService>();
  final _secretCtrl = TextEditingController();
  bool _authenticated = false;
  String? _generatedCode;
  bool _tampered = false;

  @override
  void initState() {
    super.initState();
    _checkTamper();
  }

  Future<void> _checkTamper() async {
    final tampered = await _antiTamper.wasTampered();
    if (mounted) setState(() => _tampered = tampered);
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) return _buildAuth();
    return _buildPanel();
  }

  Widget _buildAuth() {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المالك')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.admin_panel_settings, size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              const Text('دخول المالك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: _secretCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'الرمز السري', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder())),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('دخول'),
                onPressed: () {
                  if (_secretCtrl.text == widget.adminSecret) {
                    setState(() => _authenticated = true);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => launcher.launchUrl(Uri.parse('https://smart-accountant-admin.web.app')),
                child: const Text('فتح لوحة الويب'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المالك')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🔑 توليد رموز التفعيل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: ElevatedButton(onPressed: () => setState(() => _generatedCode = SubscriptionService.generateCode(SubscriptionType.semiAnnual, widget.adminSecret)), child: const Text('نصف سنوي'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () => setState(() => _generatedCode = SubscriptionService.generateCode(SubscriptionType.annual, widget.adminSecret)), child: const Text('سنوي'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), onPressed: () => setState(() => _generatedCode = SubscriptionService.generateCode(SubscriptionType.lifetime, widget.adminSecret)), child: const Text('مدى الحياة'))),
              ]),
              if (_generatedCode != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)),
                  child: Text(_generatedCode!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
              ],
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('🛡️ الأمان: ${_tampered ? '⚠️ تم اكتشاف تلاعب' : '✅ آمن'}', style: TextStyle(fontWeight: FontWeight.bold, color: _tampered ? Colors.red : Colors.green)),
              if (_tampered) ElevatedButton(onPressed: () async { await _antiTamper.resetTamperFlag(); setState(() => _tampered = false); }, child: const Text('إعادة تعيين')),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('📊 إحصائيات: ${_targets.allTargets.length} مندوبين | الهدف الشهري: ${_targets.overallTarget.monthlyTarget.toStringAsFixed(0)} ريال'),
              const SizedBox(height: 8),
              TextButton(onPressed: () {}, child: const Text('فتح لوحة الويب للتفاصيل الكاملة')),
            ]),
          ),
        ),
      ]),
    );
  }
}
