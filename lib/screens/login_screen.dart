import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const LoginScreen({super.key, required this.prefs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false;
  String? _err;

  Future<void> _login() async {
    setState(() { _busy = true; _err = null; });
    final user = await AuthService(widget.prefs).login(_email.text.trim(), _pass.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (user == null) {
      setState(() => _err = 'البريد أو كلمة المرور غير صحيحة');
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => HomeScreen(prefs: widget.prefs, email: user.email, isAdmin: user.isAdmin),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.lock_person_rounded, size: 72, color: kAccent),
              const SizedBox(height: 20),
              const Text('تسجيل الدخول', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('أدخل بيانات حسابك للمتابعة', textAlign: TextAlign.center,
                  style: TextStyle(color: kMuted)),
              const SizedBox(height: 30),
              TextField(controller: _email, decoration: const InputDecoration(
                hintText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 14),
              TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(
                hintText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline))),
              if (_err != null) Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_err!, style: const TextStyle(color: Colors.redAccent))),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _busy ? null : _login,
                child: _busy
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('دخول'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => RegisterScreen(prefs: widget.prefs))),
                child: const Text('ليس لديك حساب؟ إنشاء حساب', style: TextStyle(color: kAccent2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
