import 'package:flutter/material.dart';

class HistorialUsuarioPage extends StatelessWidget {
  const HistorialUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Historial'),
        ),
        body: const Center(
          child: Text('Vista del Historial'),
        ),
      ),
    );
  }
}
