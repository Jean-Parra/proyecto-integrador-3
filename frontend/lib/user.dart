class User {
  String id;
  String name;
  String lastname;
  String phone;
  String email;
  String password;
  String role;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        lastname: json['lastname'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        role: json['role'] ?? '');
  }
}
