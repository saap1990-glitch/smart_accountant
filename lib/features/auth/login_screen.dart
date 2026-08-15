import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/auth/auth_service.dart';
import '../dashboard/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = GetIt.I<AuthService>();
  final _pinCtrl = TextEditingController();
  final _recCtrl = TextEditingController();
  final _newCtrl = TextEditingController();

  bool _loading = true;
  bool _firstTime = true;
  bool _showPin = false;
  bool _recovery = false;
  bool _remember = true;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final hasPin = await _auth.hasPin();
    final remembered = await _auth.isSessionRemembered();
    final bioAvailable = await _auth.isBiometricAvailable();
    final bioEnabled = await _auth.isBiometricEnabled();

    if (remembered && hasPin) {
      if (bioEnabled && bioAvailable) {
        final ok = await _auth.authenticateWithBiometric();
        if (ok && mounted) { _goMain(); return; }
      }
      if (mounted) { _goMain(); return; }
    }

    setState(() {
      _firstTime = !hasPin;
      _showPin = hasPin;
      _biometricAvailable = bioAvailable;
      _biometricEnabled = bioEnabled;
      _loading = false;
    });
  }

  void _goMain() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));

  String _genCode() => List.generate(8, (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[Random().nextInt(36)]).join();

  Future<void> _biometricLogin() async {
    final ok = await _auth.authenticateWithBiometric();
    if (ok && mounted) _goMain();
  }

  Future<void> _submit() async {
    final pin = _pinCtrl.text;
    if (pin.length < 4) { setState(() => _error = 'أدخل 4 أرقام على الأقل'); return; }
    if (_firstTime) {
      await _auth.setPin(pin);
      final code = _genCode();
      await _auth.setRecoveryCode(code);
      if (_biometricAvailable) {
        await _auth.enableBiometric(true);
      }
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('رمز الاسترداد'),
          content: Text(code, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
          actions: [ElevatedButton(onPressed: () { Navigator.pop(c); _goMain(); }, child: const Text('تم'))],
        ),
      );
    } else {
      if (await _auth.verifyPin(pin)) {
        if (_remember) await _auth.rememberSession(true);
        _goMain();
      } else {
        setState(() { _error = 'الرقم غير صحيح'; _pinCtrl.clear(); });
      }
    }
  }

  Future<void> _reset() async {
    if (_newCtrl.text.length < 4) { setState(() => _error = 'أدخل 4 أرقام'); return; }
    if (await _auth.resetPinWithRecovery(_recCtrl.text.trim(), _newCtrl.text)) {
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم'))); setState(() { _recovery = false; _showPin = true; _error = ''; }); }
    } else {
      setState(() => _error = 'رمز خطأ');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFF00796B),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance, size: 64, color: Colors.white),
              const SizedBox(height: 8),
              const Text('المحاسب الذكي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: _recovery ? _buildRecovery() : _buildLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      // أيقونة البصمة (إذا متاحة ومفعلة)
      if (!_showPin && _biometricAvailable && !_firstTime)
        GestureDetector(
          onTap: _biometricLogin,
          child: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal.shade100),
            child: const Icon(Icons.fingerprint, size: 36, color: Color(0xFF00796B)),
          ),
        ),
      // زر البصمة (إذا الشاشة تظهر الرقم)
      if (_showPin && _biometricAvailable && !_firstTime)
        TextButton.icon(
          icon: const Icon(Icons.fingerprint, color: Color(0xFF00796B)),
          label: const Text('الدخول بالبصمة'),
          onPressed: _biometricLogin,
        ),
      const SizedBox(height: 8),
      Text(_firstTime ? 'إنشاء رقم سري' : 'أدخل الرقم السري', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      TextField(
        controller: _pinCtrl,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 28, letterSpacing: 10),
        decoration: InputDecoration(counterText: '', hintText: '••••••', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(vertical: 10)),
        onChanged: (_) => setState(() => _error = ''),
      ),
      if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_error, style: const TextStyle(color: Colors.red))),
      const SizedBox(height: 10),
      Row(children: [SizedBox(width: 24, child: Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v!), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)), const Text('تذكرني', style: TextStyle(fontSize: 14))]),
      const SizedBox(height: 10),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)), child: Text(_firstTime ? 'حفظ' : 'دخول'))),
      if (!_firstTime) TextButton(onPressed: () => setState(() => _recovery = true), child: const Text('نسيت كلمة السر؟')),
    ]);
  }

  Widget _buildRecovery() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.lock_reset, size: 32, color: Color(0xFF00796B)),
      const SizedBox(height: 4),
      const Text('استعادة', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: _recCtrl, decoration: InputDecoration(labelText: 'رمز الاسترداد', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.all(12))),
      const SizedBox(height: 8),
      TextField(controller: _newCtrl, obscureText: true, keyboardType: TextInputType.number, maxLength: 6, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, letterSpacing: 6), decoration: InputDecoration(labelText: 'الرقم الجديد', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), counterText: '', contentPadding: const EdgeInsets.all(12))),
      if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_error, style: const TextStyle(color: Colors.red))),
      const SizedBox(height: 12),
      Row(children: [Expanded(child: OutlinedButton(onPressed: () => setState(() { _recovery = false; _error = ''; }), child: const Text('رجوع'))), const SizedBox(width: 8), Expanded(child: ElevatedButton(onPressed: _reset, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white), child: const Text('تعيين')))]),
    ]);
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    _recCtrl.dispose();
    _newCtrl.dispose();
    super.dispose();
  }
}
