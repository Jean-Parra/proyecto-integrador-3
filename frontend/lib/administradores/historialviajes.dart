import 'package:flutter/material.dart';

class HistorialAdministradorPage extends StatelessWidget {
  const HistorialAdministradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Historial Vajes (ADMINISTRADOR)'),
        ),
        body: const Center(
          child: Text('Vista del Historial'),
        ),
      ),
    );
  }
}
