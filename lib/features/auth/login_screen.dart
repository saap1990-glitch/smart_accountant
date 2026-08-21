import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/firebase_auth_service.dart';
import '../dashboard/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _localAuth = GetIt.I<AuthService>();
  final _firebaseAuth = GetIt.I<FirebaseAuthService>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  bool _loading = false;
  String _error = '';

  // لحالة مصادقة الهاتف
  String? _verificationId;
  bool _showPhoneCode = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    final result = await _firebaseAuth.signInWithEmail(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (result?.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      setState(() {
        _loading = false;
        _error = 'فشل تسجيل الدخول بالبريد';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    final result = await _firebaseAuth.signInWithGoogle();
    if (!mounted) return;
    if (result?.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      setState(() {
        _loading = false;
        _error = 'فشل تسجيل الدخول بحساب Google';
      });
    }
  }

  Future<void> _startPhoneAuth() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    await _firebaseAuth.signInWithPhone(
      _phoneCtrl.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.confirmPhoneCode(
          _verificationId!,
          credential.smsCode!,
        );
        if (mounted)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _loading = false;
          _error = e.message ?? 'فشل التحقق من الهاتف';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _showPhoneCode = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _confirmPhoneCode() async {
    if (_verificationId == null) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    final result = await _firebaseAuth.confirmPhoneCode(
      _verificationId!,
      _codeCtrl.text.trim(),
    );
    if (!mounted) return;
    if (result?.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      setState(() {
        _loading = false;
        _error = 'رمز التحقق غير صحيح';
      });
    }
  }

  Future<void> _loginLocally() async {
    // الدخول المحلي القديم (PIN) - يمكن تحسينه لاحقًا
    if (await _localAuth.hasPin()) {
      // في النسخة الحالية نعتمد على Firebase فقط، لذا نعرض رسالة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الدخول المحلي غير مفعل، استخدم Firebase'),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('قم بإنشاء رقم سري أولاً')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00796B),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance, size: 64, color: Colors.white),
              const SizedBox(height: 8),
              const Text(
                'المحاسب الذكي',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_showPhoneCode) ...[
                      // تسجيل الدخول بالبريد
                      TextField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _signInWithEmail,
                          child: const Text('دخول بالبريد'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // زر Google
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.g_mobiledata),
                          label: const Text('دخول بحساب Google'),
                          onPressed: _loading ? null : _signInWithGoogle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // زر الهاتف
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.phone),
                          label: const Text('دخول برقم الهاتف'),
                          onPressed: () {
                            setState(() {
                              _showPhoneCode = false;
                            });
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('رقم الهاتف'),
                                content: TextField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: '+967XXXXXXXX',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('إلغاء'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      _startPhoneAuth();
                                    },
                                    child: const Text('إرسال الرمز'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // دخول محلي قديم
                      TextButton(
                        onPressed: _loginLocally,
                        child: const Text('الدخول المحلي (PIN)'),
                      ),
                    ] else ...[
                      // إدخال رمز التحقق للهاتف
                      TextField(
                        controller: _codeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'رمز التحقق',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loading ? null : _confirmPhoneCode,
                        child: const Text('تأكيد'),
                      ),
                    ],
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(_error, style: const TextStyle(color: Colors.red)),
                    ],
                    if (_loading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
