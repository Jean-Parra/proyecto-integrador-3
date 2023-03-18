import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  final dynamic jsonResponse;

  Perfil({Key? key, required this.jsonResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nombre: ${jsonResponse['user']['nombre'] ?? ""}"),
            Text("Correo electrónico: ${jsonResponse['user']['email'] ?? ""}"),
            Text("Rol: ${jsonResponse['user']['role'] ?? ""}"),
          ],
        ),
      ),
    );
  }
}
