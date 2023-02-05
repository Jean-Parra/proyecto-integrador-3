import 'package:mongo_dart/mongo_dart.dart';

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

  Future<bool> login(String email, String password) async {
    final user = await db.collection("usuarios").findOne({"correo": email});
    if (user != null && user['contrasena'] == password) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> loginconductores(String email, String password) async {
    final user = await db.collection("conductores").findOne({"correo": email});
    if (user != null && user['contrasena'] == password) {
      return true;
    } else {
      return false;
    }
  }
}

//Guia para rechazar un conductor desde mongoDB
  //var conductor = await db.collection("conductores")
    //.findOne({"email": "email_del_conductor"});

  //if (conductor != null) {
    //conductor["estado"] = "rechazado";
    //await db.collection("conductores").save(conductor);