// ignore_for_file: avoid_print

import 'package:mongo_dart/mongo_dart.dart';
import '../user.dart';

class MongoDB {
  late Db db;

  MongoDB() {
    connect();
  }

  Future<void> connect() async {
    db = await Db.create(
        "mongodb+srv://usuario_upb:contrasena_upb@cluster0.ya3bz0q.mongodb.net/proyecto?retryWrites=true&w=majority");
    await db.open();
  }

  Future<void> updatePassword(String email, String newPassword) async {
    await db.collection("usuarios").update(
      {"correo": email},
      {
        r"$set": {"contrasena": newPassword},
      },
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final user = await db.collection("usuarios").findOne({"correo": email});
    if (user != null) {
      return User(
        name: user['nombre'],
        lastname: user["apellido"],
        phone: user["telefono"],
        email: user['correo'],
        password: user["contrasena"],
        role: user['role'],
      );
    } else {
      return null;
    }
  }
}
