import 'package:flutter/material.dart';

class AdministradorPage extends StatefulWidget {
  const AdministradorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdministradorPageState createState() => _AdministradorPageState();
}

class _AdministradorPageState extends State<AdministradorPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Administrador',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Administrador'),
        ),
        body: const Center(
          child: Text('Vista del Administrador'),
        ),
      ),
    );
  }
}
