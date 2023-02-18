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

  Future<void> insert(String collection, Map<String, dynamic> data) async {
    await db.collection(collection).insert(data);
  }

  Future<List<Map<String, dynamic>>> find(String collection) async {
    var result = await db.collection(collection).find().toList();
    return result;
  }

  Future<void> update(String collection, Map<String, dynamic> selector,
      Map<String, dynamic> data) async {
    await db.collection(collection).update(selector, data);
  }

  Future<void> delete(String collection, Map<String, dynamic> data) async {
    await db.collection(collection).remove(data);
  }

  Future<void> close() async {
    await db.close();
  }

  Future<User?> login(String email, String password) async {
    final user = await db.collection("usuarios").findOne({"correo": email});
    if (user != null && user['contrasena'] == password) {
      return User(
          name: user['nombre'],
          lastname: user["apellido"],
          phone: user["telefono"],
          email: user['correo'],
          password: user["contrasena"],
          type: user['tipo']);
    } else {
      return null;
    }
  }
}
