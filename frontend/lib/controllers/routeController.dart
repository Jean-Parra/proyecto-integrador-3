// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/solicitudes.dart';
import '../Models/vieja.dart';

class GuardarViaje {
  Future<void> saveViaje(
    String email,
    String origin,
    String destination,
    double distance,
    int price,
    String selectedOption,
  ) async {
    const String url = "http://192.168.20.22/solicitudes";

    try {
      final response = await http.post(Uri.parse(url), body: {
        "email": email,
        "origin": origin,
        "destination": destination,
        "distance": distance.toString(),
        "price": price.toString(),
        "selectedOption": selectedOption,
      });

      if (response.statusCode == 201) {
        print("Viaje guardado correctamente");
      } else {
        throw Exception("Error al guardar el viaje");
      }
    } catch (error) {
      print("no se que paso");
      throw Exception("Error al guardar el viaje: ${error.toString()}");
    }
  }
}

class Datos {
  Future<Map<String, dynamic>> Obtener() async {
    const url = 'http://192.168.20.22/prices';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Error al buscar precios');
    }
  }
}

class MostrarSolicitudes {
  Future<List<Solicitud>> fetchSolicitudes() async {
    final url = Uri.parse('http://192.168.20.22/solicitudes/activas');
    final response = await http.get(url);

    if (response.statusCode == 201) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final jsonList = jsonMap['solicitudes'] as List<dynamic>;
      return jsonList.map((json) => Solicitud.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las solicitudes');
    }
  }
}

class GuardarViajes {
  Future<void> aceptarSolicitud(
    String user,
    String driver,
    String origin,
    String destination,
    double distance,
    int price,
    String selectedOption,
  ) async {
    const String url = "http://192.168.20.22/solicitudes/aceptar";
    try {
      final response = await http.post(Uri.parse(url), body: {
        "user": user,
        "driver": driver,
        "origin": origin,
        "destination": destination,
        "distance": distance.toString(),
        "price": price.toString(),
        "selectedOption": selectedOption,
      });

      if (response.statusCode == 201) {
        print("viaje aceptado");
      } else {
        print(response.statusCode);
        throw Exception('Error al aceptar la solicitud');
      }
    } catch (error) {
      throw Exception("Error al guardar el viaje: ${error.toString()}");
    }
  }
}

class ObtenerViajes {
  Future<List<Viaje>> obtenerSolicitudesAceptadas() async {
    const String url = "http://192.168.20.22/solicitudes/aceptadas";
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        // Aquí puedes procesar los datos de respuesta
        final data = jsonDecode(response.body);
        return List<Viaje>.from(data.map((viaje) => Viaje.fromJson(viaje)));
      } else {
        throw Exception('Error al obtener las solicitudes aceptadas');
      }
    } catch (error) {
      throw Exception('Error de conexión: $error');
    }
  }
}
