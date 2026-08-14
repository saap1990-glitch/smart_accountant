import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _nameCtrl.text = await _storage.read(key: 'profile_name') ?? '';
    _addressCtrl.text = await _storage.read(key: 'profile_address') ?? '';
    _phoneCtrl.text = await _storage.read(key: 'profile_phone') ?? '';
    _emailCtrl.text = await _storage.read(key: 'profile_email') ?? '';
    _usernameCtrl.text = await _storage.read(key: 'profile_username') ?? '';
    setState(() {});
  }

  Future<void> _saveProfile() async {
    await _storage.write(key: 'profile_name', value: _nameCtrl.text);
    await _storage.write(key: 'profile_address', value: _addressCtrl.text);
    await _storage.write(key: 'profile_phone', value: _phoneCtrl.text);
    await _storage.write(key: 'profile_email', value: _emailCtrl.text);
    await _storage.write(key: 'profile_username', value: _usernameCtrl.text);
    if (_passwordCtrl.text.isNotEmpty) {
      await _storage.write(key: 'profile_password', value: _passwordCtrl.text);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البيانات بنجاح ✅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البيانات الشخصية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field('الاسم', Icons.person, _nameCtrl),
          _field('العنوان', Icons.location_on, _addressCtrl),
          _field('رقم التلفون', Icons.phone, _phoneCtrl, keyboardType: TextInputType.phone),
          _field('البريد الإلكتروني', Icons.email, _emailCtrl, keyboardType: TextInputType.emailAddress),
          _field('اسم المستخدم', Icons.account_circle, _usernameCtrl),
          _field('كلمة السر', Icons.lock, _passwordCtrl, obscure: true),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ البيانات'),
            onPressed: _saveProfile,
          ),
        ],
      ),
    );
  }

  Widget _field(String label, IconData icon, TextEditingController ctrl, {bool obscure = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
