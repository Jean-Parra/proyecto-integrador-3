// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/controllers/userController.dart';
import 'package:proyecto_integrador_3/user.dart';

class ListConductoresScreen extends StatefulWidget {
  const ListConductoresScreen({super.key});

  @override
  _ListConductoresScreenState createState() => _ListConductoresScreenState();
}

class _ListConductoresScreenState extends State<ListConductoresScreen> {
  final _obtenerConductores = ObtenerConductores();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de conductores'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<User>>(
        future: _obtenerConductores.getConductores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al obtener los conductores'));
          } else {
            final List<User> conductores = snapshot.data!;
            if (conductores.isEmpty) {
              return const Center(
                  child: Text('La lista de conductores está vacía'));
            }
            return ListView.builder(
              itemCount: conductores.length,
              itemBuilder: (context, index) {
                return ConductorListItem(conductor: conductores[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class ConductorListItem extends StatelessWidget {
  final User conductor;

  const ConductorListItem({Key? key, required this.conductor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          '${conductor.name} ${conductor.lastname}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Teléfono: ${conductor.phone}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Email: ${conductor.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Contraseña Encriptada: ${conductor.password}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
