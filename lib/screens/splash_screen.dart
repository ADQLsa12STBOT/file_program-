import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const SplashScreen({super.key, required this.prefs});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final auth = AuthService(widget.prefs);
    final email = auth.currentEmail;
    if (!mounted) return;
    if (email != null) {
      final isAdmin = email == 'admin';
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => HomeScreen(prefs: widget.prefs, email: email, isAdmin: isAdmin),
      ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => LoginScreen(prefs: widget.prefs),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_special_rounded, size: 90, color: kAccent),
            const SizedBox(height: 18),
            const Text('File Program', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kText)),
            const SizedBox(height: 8),
            const Text('Dv: @it55u', style: TextStyle(color: kMuted)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: kAccent),
          ],
        ),
      ),
    );
  }
}
