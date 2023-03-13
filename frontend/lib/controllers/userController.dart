// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:get/get.dart';
import '../login_form.dart';
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
    var response = await http.post(Uri.parse("http://192.168.0.28:3000/signin"),
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
    final uri = Uri.parse("http://192.168.0.28:3000/signup");
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
    final url = Uri.parse('http://192.168.0.28:3000/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}

class VerificarToken {
  Future<void> checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      print("token vacio");
      Get.to(() => const LoginPage());
    } else {
      final url = Uri.parse('http://192.168.0.28:3000/user');
      final headers = {
        'x-access-token': sharedPreferences.getString("token") ?? '',
        'Content-Type': 'application/json'
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        switch (user.role) {
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
            print('Rol de usuario desconocido: ${user.role}');
        }
      } else {
        print(response.body);
      }
    }
  }
}

class EliminarUsuario {
  Future<void> eliminarUsuario(String email, String deleteRazon) async {
    final uri = Uri.parse('http://192.168.0.28:3000/users/$email');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'deleteReason': deleteRazon});

    final response = await http.delete(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Usuario eliminado.');
    } else {
      print('Error al eliminar usuario: ${response.statusCode}');
    }
  }
}

class ObtenerUsuario {
  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final response =
        await http.get(Uri.parse('http://192.168.0.28:3000/users/$email'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener el usuario: ${response.reasonPhrase}');
    }
  }
}

class CambiarContrasena {
  Future<void> updatePassword(String email, String newPassword) async {
    final url = Uri.parse('http://192.168.0.28:3000/users/:password');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'email': email, 'newPassword': newPassword});

    final response = await http.put(url, headers: headers, body: body);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print(responseData['message']);
    } else {
      throw Exception(responseData['message']);
    }
  }
}
