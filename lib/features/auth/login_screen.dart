import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/auth/auth_service.dart';
import '../dashboard/main_screen.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinCtrl = TextEditingController();
  bool _firstTime = true;
  bool _remember = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final auth = GetIt.I<AuthService>();
      final hasPin = await auth.hasPin();
      final remembered = await auth.isSessionRemembered();
      if (remembered && hasPin && mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else if (mounted) {
        setState(() => _firstTime = !hasPin);
      }
    } catch (_) {
      setState(() => _firstTime = true);
    }
  }

  Future<void> _submit() async {
    final pin = _pinCtrl.text;
    if (pin.length < 4) { setState(() => _error = 'أدخل 4 أرقام على الأقل'); return; }
    try {
      final auth = GetIt.I<AuthService>();
      if (_firstTime) {
        await auth.setPin(pin);
        final code = List.generate(8, (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[Random().nextInt(36)]).join();
        await auth.setRecoveryCode(code);
        if (_remember) await auth.rememberSession(true);
        if (mounted) {
          showDialog(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('رمز الاسترداد'),
              content: Text(code, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
              actions: [ElevatedButton(onPressed: () { Navigator.pop(c); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen())); }, child: const Text('تم'))],
            ),
          );
        }
      } else {
        if (await auth.verifyPin(pin)) {
          if (_remember) await auth.rememberSession(true);
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
        } else {
          setState(() { _error = 'الرقم غير صحيح'; _pinCtrl.clear(); });
        }
      }
    } catch (e) {
      setState(() => _error = 'خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_firstTime ? 'إنشاء رقم سري' : 'أدخل الرقم السري', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pinCtrl,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, letterSpacing: 10),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '••••••',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onChanged: (_) => setState(() => _error = ''),
                    ),
                    if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_error, style: const TextStyle(color: Colors.red))),
                    const SizedBox(height: 10),
                    Row(children: [
                      SizedBox(width: 24, child: Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v!), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)),
                      const Text('تذكرني', style: TextStyle(fontSize: 14)),
                    ]),
                    const SizedBox(height: 10),
                    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)), child: Text(_firstTime ? 'حفظ' : 'دخول'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }
}
