import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/auth/auth_service.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _auth = GetIt.I<AuthService>();
  final _oldPinCtrl = TextEditingController();
  final _newPinCtrl = TextEditingController();
  final _confirmPinCtrl = TextEditingController();
  bool _pinEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    final hasPin = await _auth.hasPin();
    setState(() => _pinEnabled = hasPin);
  }

  Future<void> _changePin() async {
    if (_newPinCtrl.text != _confirmPinCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرقم السري غير متطابق')),
      );
      return;
    }
    if (_newPinCtrl.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرقم السري يجب أن يكون 4 أرقام على الأقل')),
      );
      return;
    }
    final success = await _auth.changePin(_oldPinCtrl.text, _newPinCtrl.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'تم تغيير الرقم السري بنجاح ✅' : 'الرقم السري القديم غير صحيح ❌')),
      );
      if (success) {
        _oldPinCtrl.clear();
        _newPinCtrl.clear();
        _confirmPinCtrl.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خيارات الأمان')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('تفعيل كلمة السر'),
            subtitle: const Text('حماية التطبيق برقم سري'),
            value: _pinEnabled,
            onChanged: (v) async {
              if (v) {
                setState(() => _pinEnabled = true);
              } else {
                await _auth.logout();
                setState(() => _pinEnabled = false);
              }
            },
          ),
          if (_pinEnabled) ...[
            const Divider(),
            const Text('تغيير كلمة السر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _oldPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'كلمة السر القديمة', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'كلمة السر الجديدة', prefixIcon: Icon(Icons.lock)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'تأكيد كلمة السر', prefixIcon: Icon(Icons.lock)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('تغيير كلمة السر'),
              onPressed: _changePin,
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _oldPinCtrl.dispose();
    _newPinCtrl.dispose();
    _confirmPinCtrl.dispose();
    super.dispose();
  }
}
