class User {
  String _id;
  String name;
  String lastname;
  String phone;
  String email;
  String password;
  String role;

  User({
    required String id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
  }) : _id = id;

  String get id => _id;

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
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
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        lastname: json['lastname'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        role: json['role'] ?? '');
  }
}
