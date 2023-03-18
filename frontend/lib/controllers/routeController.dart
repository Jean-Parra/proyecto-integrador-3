// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../user.dart';

class GuardarViaje {
  Future<void> saveViaje(
    User user,
    String origin,
    String destination,
    double distance,
    int price,
    String selectedOption,
  ) async {
    const String url = "http://207.248.81.66/solicitudes";
    final Map<String, dynamic> viaje = {
      "user": user.toJson(),
      "origin": origin,
      "destination": destination,
      "distance": distance,
      "price": price,
      "selectedOption": selectedOption,
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(viaje),
    );

    if (response.statusCode == 200) {
      print("Viaje guardado correctamente");
    } else {
      throw Exception("Error al guardar el viaje");
    }
  }
}

class Datos {
  Future<Map<String, dynamic>> Obtener() async {
    const url = 'http://207.248.81.66/prices';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Error al buscar precios');
    }
  }
}
