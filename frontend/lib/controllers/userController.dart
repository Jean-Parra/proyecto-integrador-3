// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:get/get.dart';
import '/conductores/conductor.dart';
import '/user.dart';
import '/usuarios/usuario.dart';
import '/administradores/administrador.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController {
  String errorMessage = "";
  bool isLoading = false;

  Future<void> signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    // ignore: avoid_init_to_null
    var jsonResponse = null;
    var response = await http.post(Uri.parse("http://172.19.16.1:3000/signin"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        isLoading = false;
        await sharedPreferences.setString("token", jsonResponse['token']);
        User user = User.fromJson(jsonResponse['user']);
        switch (jsonResponse['user']['role']) {
          case 'administrador':
            print("administrador");
            Get.to(() => AdministradorPage(user: user));
            break;
          case 'usuario':
            print("usuario");
            Get.to(() => UsuarioPage(user: user));
            break;
          case 'conductor':
            print("conductor");
            Get.to(() => ConductorPage(user: user));
            break;
          default:
            print(
                'Rol de usuario desconocido: ${jsonResponse['user']['role']}');
        }
      }
    } else {
      errorMessage = response.body;
      isLoading = false;
      print(response.body);
    }
  }
}

class RegisterController {
  String errorMessage = "";
  bool isLoading = false;

  late SharedPreferences sharedPreferences;

  Future<void> register(String name, String lastname, String phone,
      String email, String password, String role) async {
    final uri = Uri.parse("http://172.19.16.1:3000/signup");
    final response = await http.post(uri, body: {
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role
    });
    // ignore: avoid_init_to_null
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        isLoading = false;
        await sharedPreferences.setString("token", jsonResponse['token']);
        User user = User.fromJson(jsonResponse['user']);
        switch (jsonResponse['user']['role']) {
          case 'administrador':
            print("administrador");
            Get.to(() => AdministradorPage(user: user));
            break;
          case 'usuario':
            print("usuario");
            Get.to(() => UsuarioPage(user: user));
            break;
          case 'conductor':
            print("conductor");
            Get.to(() => ConductorPage(user: user));
            break;
          default:
            print(
                'Rol de usuario desconocido: ${jsonResponse['user']['role']}');
        }
      }
    } else {
      errorMessage = response.body;
      isLoading = false;
      print(response.body);
    }
  }
}

class ObtenerUsuarios {
  Future<List<User>> getUsers() async {
    final url = Uri.parse('http://172.19.16.1:3000/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
