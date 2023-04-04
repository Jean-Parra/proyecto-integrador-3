// ignore_for_file: avoid_print, file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
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
  var jsonResponse; // Declaración de jsonResponse

  Future<void> signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    // ignore: avoid_init_to_null
    var jsonResponse = null;
    var response =
        await http.post(Uri.parse("http://207.248.81.66/signin"), body: data);
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
      Get.snackbar(
        "Error",
        "Correo o contraseña incorrectos. Por favor verifique e intente nuevamente.",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class PerfilController extends GetxController {
  var isLoading = true.obs;
  User? user;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token != null) {
      var response = await http.get(
        Uri.parse("http://207.248.81.66/users"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Response status PERFIL: ${response.statusCode}');
        print('Response body PERFIL: ${response.body}');
        if (jsonResponse != null) {
          user = User.fromJson(jsonResponse);
        }
      } else {
        print(response.body);
        // Manejo de errores
      }
    } else {
      print('El usuario no ha iniciado sesión');
      // Manejo de errores
    }
    isLoading.value = false;
    print('isLoading: ${isLoading.value}');
    print('user: ${user?.toJson()}');
  }
}

class RegisterController {
  String errorMessage = "";
  bool isLoading = false;

  late SharedPreferences sharedPreferences;

  Future<void> register(String name, String lastname, String phone,
      String email, String password, String role) async {
    final uri = Uri.parse("http://207.248.81.66/signup");
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

class ObtenerPersonas {
  Future<List<User>> getUsers() async {
    final url = Uri.parse('http://207.248.81.66/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}

class ObtenerUsuarios {
  Future<List<User>> getUsuarios() async {
    final url = Uri.parse('http://207.248.81.66/usuarios');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      final List<User> allUsers =
          decodedData.map((user) => User.fromJson(user)).toList();
      print('Todos los usuarios: $allUsers');
      final List<User> filteredUsers =
          allUsers.where((user) => user.role == 'usuario').toList();
      print('Usuarios filtrados: $filteredUsers');
      return filteredUsers;
    } else {
      print(
          'Error de red: código de estado ${response.statusCode}, cuerpo de la respuesta: ${response.body}');
      throw Exception('Error al cargar los usuarios');
    }
  }
}

class UserID {
  static Future<User> getUsuarioActual(String id) async {
    final url = Uri.parse('http://207.248.81.66/usuarios/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic decodedData = json.decode(response.body);

      try {
        final Map<String, dynamic> jsonMap =
            decodedData is String ? json.decode(decodedData) : decodedData;
        final User user = User.fromJson(jsonMap);
        return user;
      } catch (e) {
        print(
            'Error al decodificar la respuesta del servidor: ${response.body}');
        throw Exception('Error al cargar el usuario actual2');
      }
    } else {
      print(
          'Error de red: código de estado ${response.statusCode}, cuerpo de la respuesta: ${response.body}');
      throw Exception('Error al cargar el usuario actual1');
    }
  }
}

class ObtenerConductores {
  Future<List<User>> getConductores() async {
    final url = Uri.parse('http://207.248.81.66/conductores');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      final List<User> allUsers =
          decodedData.map((user) => User.fromJson(user)).toList();
      final List<User> filteredUsers =
          allUsers.where((user) => user.role == 'conductor').toList();
      return filteredUsers;
    } else {
      print(
          'Error de red: código de estado ${response.statusCode}, cuerpo de la respuesta: ${response.body}');
      throw Exception('Error al cargar los conductores');
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
      final url = Uri.parse('http://207.248.81.66/user');
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
    final uri = Uri.parse('http://207.248.81.66/users/$email');
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
        await http.get(Uri.parse('http://207.248.81.66/users/$email'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener el usuario: ${response.reasonPhrase}');
    }
  }
}

class CambiarContrasena {
  Future<void> updatePassword(String email, String newPassword) async {
    final url = Uri.parse('http://207.248.81.66/users/:password');
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

class EditingUser {
  static void editarUsuarioActual(
    String id,
    String nombre,
    String email,
    String telefono,
  ) async {
    const String apiUrl =
        'http://207.248.81.66/usuarios/6410f01d990cdd8b849e90ea';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'name': nombre,
      'email': email,
      'phone': telefono,
    };

    final String jsonBody = jsonEncode(body);

    try {
      final http.Response response =
          await http.put(Uri.parse(apiUrl), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        // El usuario fue actualizado correctamente
        print('Usuario actualizado correctamente');
      } else {
        // Hubo un error al actualizar el usuario
        print(
            'Error al actualizar el usuario. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // Hubo un error en la petición HTTP
      print('Error al actualizar el usuario: $e');
    }
  }
}
