import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// تسجيل الدخول بالبريد وكلمة المرور
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  /// إنشاء حساب بالبريد وكلمة المرور
  Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  /// تسجيل الدخول بحساب Google عبر OAuthProvider (بدون google_sign_in)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      return await _auth.signInWithProvider(provider);
    } catch (e) {
      return null;
    }
  }

  /// تسجيل الدخول برقم الهاتف (يرسل رمز تحقق)
  Future<void> signInWithPhone(
    String phoneNumber, {
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  /// إدخال رمز التحقق وإكمال تسجيل الدخول
  Future<UserCredential?> confirmPhoneCode(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;
}
