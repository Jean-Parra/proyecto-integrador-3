import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/custom_drawer.dart';
import '../database/mongo.dart'; // importa MongoDB
import 'package:proyecto_integrador_3/user.dart'; // importa User
import 'userList.dart';

class AdministradorPage extends StatefulWidget {
  final User user;
  const AdministradorPage({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdministradorPageState createState() => _AdministradorPageState();
}

class _AdministradorPageState extends State<AdministradorPage> {
  MongoDB mongodb = MongoDB();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Administrador',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Administrador'),
        ),
        drawer: CustomDrawer(
          profileName: "administrador",
          user: widget.user,
        ),
        body: const Center(
          child: Text(
            'Vista del Administrador',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ListaUsuariosPage(),
              ),
            );
          },
          child: const Icon(Icons.people),
        ),
      ),
    );
  }
}
