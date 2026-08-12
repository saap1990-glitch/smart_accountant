import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/auth/auth_service.dart';
import '../dashboard/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _auth = GetIt.I<AuthService>();
  final _pinController = TextEditingController();
  final _recoveryController = TextEditingController();
  final _newPinController = TextEditingController();
  
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = true;
  bool _isFirstTime = true;
  bool _showPinInput = false;
  bool _showRecovery = false;
  bool _rememberMe = true;
  String _errorMessage = '';
  int _pinLength = 6;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final hasPin = await _auth.hasPin();
    final remembered = await _auth.isSessionRemembered();
    
    if (remembered && !hasPin) {
      _goToMain();
      return;
    }
    
    setState(() {
      _isFirstTime = !hasPin;
      _showPinInput = hasPin;
      _isLoading = false;
    });
    _animController.forward();
  }

  void _goToMain() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _handlePinSubmit() async {
    final pin = _pinController.text;
    if (pin.length != _pinLength) {
      setState(() => _errorMessage = 'أدخل 6 أرقام');
      return;
    }

    if (await _auth.verifyPin(pin)) {
      if (_rememberMe) await _auth.rememberSession(true);
      _goToMain();
    } else {
      setState(() => _errorMessage = 'الرقم السري غير صحيح');
      _pinController.clear();
    }
  }

  Future<void> _handleSetPin() async {
    final pin = _pinController.text;
    if (pin.length != _pinLength) {
      setState(() => _errorMessage = 'أدخل 6 أرقام');
      return;
    }
    
    await _auth.setPin(pin);
    final code = _generateRecoveryCode();
    await _auth.setRecoveryCode(code);
    
    _showRecoveryDialog(code);
  }

  Future<void> _handleRecovery() async {
    final code = _recoveryController.text;
    final newPin = _newPinController.text;
    
    if (newPin.length != _pinLength) {
      setState(() => _errorMessage = 'أدخل رقماً سرياً جديداً من 6 أرقام');
      return;
    }
    
    if (await _auth.resetPinWithRecovery(code, newPin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إعادة تعيين الرقم السري بنجاح')),
      );
      setState(() {
        _showRecovery = false;
        _showPinInput = true;
      });
    } else {
      setState(() => _errorMessage = 'رمز الاسترداد غير صحيح');
    }
  }

  String _generateRecoveryCode() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13);
  }

  void _showRecoveryDialog(String code) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.key, color: Colors.teal),
            SizedBox(width: 8),
            Text('رمز الاسترداد'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('احفظ هذا الرمز لاستعادة كلمة السر:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
            ),
            const SizedBox(height: 8),
            const Text('يمكنك نسخه أو تصويره', style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _goToMain();
            },
            child: const Text('تم الحفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF006D5B)
                  : const Color(0xFF0F1412),
              Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF4A635E)
                  : const Color(0xFF1A1C1B),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الشعار
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'المحاسب الذكي',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Enterprise',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // بطاقة تسجيل الدخول
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (!_showRecovery) ...[
                              // أيقونة البصمة
                              if (!_showPinInput)
                                GestureDetector(
                                  onTap: () => setState(() => _showPinInput = true),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF006D5B), Color(0xFF4ED9B2)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(Icons.fingerprint, size: 40, color: Colors.white),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text(
                                _isFirstTime ? 'إنشاء رقم سري' : 'أدخل الرقم السري',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),

                              // حقل الرقم السري
                              TextField(
                                controller: _pinController,
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                maxLength: _pinLength,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 28, letterSpacing: 12),
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: '••••••',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 12),
                                ),
                                onChanged: (_) {
                                  if (_errorMessage.isNotEmpty) {
                                    setState(() => _errorMessage = '');
                                  }
                                },
                              ),
                              
                              // رسالة خطأ
                              if (_errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red, fontSize: 14),
                                  ),
                                ),
                              const SizedBox(height: 16),

                              // تذكرني
                              CheckboxListTile(
                                value: _rememberMe,
                                onChanged: (v) => setState(() => _rememberMe = v!),
                                title: const Text('تذكر الجلسة'),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 8),

                              // زر الدخول
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isFirstTime ? _handleSetPin : _handlePinSubmit,
                                  child: Text(_isFirstTime ? 'حفظ الرقم السري' : 'دخول'),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // نسيت كلمة السر
                              if (!_isFirstTime)
                                TextButton(
                                  onPressed: () => setState(() => _showRecovery = true),
                                  child: const Text('نسيت كلمة السر؟'),
                                ),
                            ],

                            // شاشة الاسترداد
                            if (_showRecovery) ...[
                              const Icon(Icons.lock_reset, size: 50, color: Colors.teal),
                              const SizedBox(height: 16),
                              const Text(
                                'استعادة كلمة السر',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: _recoveryController,
                                decoration: const InputDecoration(
                                  labelText: 'رمز الاسترداد',
                                  hintText: 'أدخل رمز الاسترداد الذي حفظته',
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _newPinController,
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                maxLength: _pinLength,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: 'الرقم السري الجديد',
                                ),
                              ),
                              if (_errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                                ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => setState(() {
                                        _showRecovery = false;
                                        _errorMessage = '';
                                      }),
                                      child: const Text('رجوع'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _handleRecovery,
                                      child: const Text('إعادة تعيين'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _pinController.dispose();
    _recoveryController.dispose();
    _newPinController.dispose();
    super.dispose();
  }
}
