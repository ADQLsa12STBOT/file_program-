import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import '../widgets/gradient_button.dart';
import 'category_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final SharedPreferences prefs;
  final String email;
  final bool isAdmin;

  const HomeScreen({super.key, required this.prefs, required this.email, required this.isAdmin});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('أهلاً بكم في تطبيق', style: TextStyle(color: kMuted, fontSize: 14)),
                      const Text('File Program', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: kAccent),
                    onSelected: (v) async {
                      if (v == 'logout') {
                        await AuthService(prefs).logout();
                        if (!context.mounted) return;
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => LoginScreen(prefs: prefs)));
                      } else if (v == 'admin') {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => AdminScreen(prefs: prefs)));
                      }
                    },
                    itemBuilder: (_) => [
                      if (isAdmin) const PopupMenuItem(value: 'admin', child: Text('لوحة المطور')),
                      const PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(colors: [Color(0xFF1A1230), Color(0xFF0F1A22)]),
                  border: Border.all(color: const Color(0xFF26263A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin_circle, color: kAccent2, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isAdmin ? 'المطور' : 'المستخدم', style: const TextStyle(color: kMuted, fontSize: 12)),
                          Text(email, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('الأقسام', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GradientButton(
                label: 'ملفات Python',
                icon: Icons.code,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CategoryScreen(prefs: prefs, category: 'python', title: 'ملفات Python'))),
              ),
              GradientButton(
                label: 'ملفات JavaScript',
                icon: Icons.javascript,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CategoryScreen(prefs: prefs, category: 'javascript', title: 'ملفات JavaScript'))),
              ),
              GradientButton(
                label: 'ملفات SO',
                icon: Icons.memory,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CategoryScreen(prefs: prefs, category: 'so', title: 'ملفات SO'))),
              ),
              GradientButton(
                label: 'بوتات Telegram',
                icon: Icons.smart_toy,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CategoryScreen(prefs: prefs, category: 'telegram', title: 'بوتات Telegram'))),
              ),
              const SizedBox(height: 20),
              const Text('تواصل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GradientButton(
                label: 'التواصل مع المطور',
                icon: Icons.telegram,
                onTap: () => _open('https://t.me/it55u'),
              ),
              GradientButton(
                label: 'المساعد الذكي',
                icon: Icons.psychology,
                onTap: () => _open('https://chat.deepseek.com'),
              ),
              const SizedBox(height: 30),
              const Divider(color: Color(0xFF26263A)),
              const SizedBox(height: 10),
              const Text(
                'حقوقي وتم صنع التطبيق بواسطة Dv: @it55u\nوجميع الحقوق محفوظة © 2026',
                textAlign: TextAlign.center,
                style: TextStyle(color: kMuted, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
