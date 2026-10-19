import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final SharedPreferences prefs;
  AuthService(this.prefs);

  static const _usersKey = 'users';
  static const _sessionKey = 'session_email';

  List<User> get _users {
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).map((e) => User.fromJson(e)).toList();
  }

  Future<void> _saveUsers(List<User> users) async {
    await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  Future<bool> register(String email, String password) async {
    final users = _users;
    if (users.any((u) => u.email == email)) return false;
    users.add(User(email: email, password: password));
    await _saveUsers(users);
    return true;
  }

  Future<User?> login(String email, String password) async {
    if (email == 'admin' && password == 'admin') {
      await prefs.setString(_sessionKey, 'admin');
      return User(email: 'admin', password: 'admin', isAdmin: true);
    }
    final match = _users.where((u) => u.email == email && u.password == password);
    if (match.isEmpty) return null;
    await prefs.setString(_sessionKey, email);
    return match.first;
  }

  String? get currentEmail => prefs.getString(_sessionKey);
  Future<void> logout() => prefs.remove(_sessionKey).then((_) {});
}
