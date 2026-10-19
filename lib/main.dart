import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(FileProgramApp(prefs: prefs));
}

class FileProgramApp extends StatelessWidget {
  final SharedPreferences prefs;
  const FileProgramApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Program',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: SplashScreen(prefs: prefs),
    );
  }
}
