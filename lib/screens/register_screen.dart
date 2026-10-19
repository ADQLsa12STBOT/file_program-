import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const RegisterScreen({super.key, required this.prefs});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _err;

  Future<void> _register() async {
    if (_email.text.trim().isEmpty || _pass.text.length < 4) {
      setState(() => _err = 'البريد مطلوب وكلمة المرور 4 أحرف على الأقل');
      return;
    }
    final ok = await AuthService(widget.prefs).register(_email.text.trim(), _pass.text);
    if (!mounted) return;
    if (!ok) {
      setState(() => _err = 'الحساب موجود مسبقاً');
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _email, decoration: const InputDecoration(
              hintText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 14),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(
              hintText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline))),
            if (_err != null) Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_err!, style: const TextStyle(color: Colors.redAccent))),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _register, child: const Text('إنشاء')),
          ],
        ),
      ),
    );
  }
}
