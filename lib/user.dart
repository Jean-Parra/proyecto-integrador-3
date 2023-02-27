class User {
  String name;
  String lastname;
  String phone;
  String email;
  String password;
  String type;

  User({
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.password,
    required this.type,
  });

  static fromMap(Map<String, dynamic> e) {}

  static map(Function(dynamic e) param0) {}
}
