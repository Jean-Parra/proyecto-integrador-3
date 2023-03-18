import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/controllers/userController.dart';
import 'package:proyecto_integrador_3/user.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({super.key});

  final _obtenerUsuarios = ObtenerUsuarios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<User>>(
        future: _obtenerUsuarios.getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al obtener los usuarios'));
          } else {
            final List<User> users = snapshot.data!;
            if (users.isEmpty) {
              return const Center(
                  child: Text('La lista de usuarios está vacía'));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserListItem(user: users[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          '${user.name} ${user.lastname}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Teléfono: ${user.phone}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Contraseña Encriptada: ${user.password}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
