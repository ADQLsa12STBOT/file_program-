class User {
  final String email;
  final String password;
  final bool isAdmin;

  User({required this.email, required this.password, this.isAdmin = false});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'isAdmin': isAdmin,
      };

  factory User.fromJson(Map<String, dynamic> j) => User(
        email: j['email'],
        password: j['password'],
        isAdmin: j['isAdmin'] ?? false,
      );
}
