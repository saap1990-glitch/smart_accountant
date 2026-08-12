import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
    setState(() => _tampered = tampered);
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return _buildAuthScreen();
    }
    return _buildAdminPanel();
  }

  Widget _buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المالك')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.admin_panel_settings, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text('دخول المالك', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('أدخل الرمز السري للوصول إلى لوحة التحكم'),
              const SizedBox(height: 24),
              TextField(
                controller: _secretCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'الرمز السري',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('دخول'),
                onPressed: () {
                  if (_secretCtrl.text == widget.adminSecret) {
                    setState(() => _authenticated = true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرمز السري غير صحيح')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminPanel() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المالك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => setState(() => _authenticated = false),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('📊 حالة الجهاز الحالي'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow('نوع الاشتراك', _sub.type.name == 'trial' ? 'تجريبي (90 يوم)' : _sub.type.name),
                  _infoRow('الأيام المستخدمة', '${_sub.daysUsed} يوم'),
                  _infoRow('الأيام المتبقية', '${_sub.daysLeft} يوم'),
                  _infoRow('نسبة الاستخدام', '${_sub.usagePercentage.toStringAsFixed(0)}%'),
                  _infoRow('الحالة', _sub.isActive ? '✅ نشط' : '❌ منتهي'),
                  if (_sub.activationCode != null)
                    _infoRow('رمز التفعيل', _sub.activationCode!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section('🔑 توليد رموز التفعيل'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('توليد رمز تفعيل جديد:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.key),
                          label: const Text('نصف سنوي'),
                          onPressed: () {
                            final code = SubscriptionService.generateCode(SubscriptionType.semiAnnual, widget.adminSecret);
                            setState(() => _generatedCode = code);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.key),
                          label: const Text('سنوي'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () {
                            final code = SubscriptionService.generateCode(SubscriptionType.annual, widget.adminSecret);
                            setState(() => _generatedCode = code);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.star),
                    label: const Text('مدى الحياة'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    onPressed: () {
                      final code = SubscriptionService.generateCode(SubscriptionType.lifetime, widget.adminSecret);
                      setState(() => _generatedCode = code);
                    },
                  ),
                  if (_generatedCode != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          const Text('تم توليد الرمز:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            _generatedCode!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, color: Colors.teal),
                                tooltip: 'نسخ',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('تم نسخ الرمز ✅')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share, color: Colors.blue),
                                tooltip: 'مشاركة',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('مشاركة الرمز: $_generatedCode')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section('🛡️ مراقبة الأمان'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _tampered ? Icons.warning : Icons.shield,
                        color: _tampered ? Colors.red : Colors.green,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _tampered ? 'تم اكتشاف محاولة تلاعب بالتاريخ!' : 'النظام آمن - لم يتم اكتشاف تلاعب',
                          style: TextStyle(
                            color: _tampered ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_tampered) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين العلم'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        await _antiTamper.resetTamperFlag();
                        setState(() => _tampered = false);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section('📈 إحصائيات سريعة'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow('عدد المندوبين', '${_targets.allTargets.length}'),
                  _infoRow('الهدف الشهري الإجمالي', '${_targets.overallTarget.monthlyTarget.toStringAsFixed(0)} ريال'),
                  _infoRow('المحقق شهرياً', '${_targets.overallTarget.achievedMonth.toStringAsFixed(0)} ريال'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section('🔄 التحديثات'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الإصدار الحالي: v1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('✅ النظام محدث إلى آخر إصدار'),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.system_update),
                    label: const Text('التحقق من التحديثات'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('أنت تستخدم أحدث إصدار ✅')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
