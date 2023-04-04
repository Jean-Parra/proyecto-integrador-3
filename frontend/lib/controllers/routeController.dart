// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

class GuardarViaje {
  Future<void> saveViaje(
    String email,
    String origin,
    String destination,
    double distance,
    int price,
    String selectedOption,
  ) async {
    const String url = "http://207.248.81.66/solicitudes";

    try {
      final response = await http.post(Uri.parse(url), body: {
        "email": email,
        "origin": origin,
        "destination": destination,
        "distance": distance,
        "price": price,
        "selectedOption": selectedOption,
      });

      if (response.statusCode == 201) {
        print("Viaje guardado correctamente");
      } else {
        throw Exception("Error al guardar el viaje");
      }
    } catch (error) {
      throw Exception("Error al guardar el viaje: ${error.toString()}");
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
