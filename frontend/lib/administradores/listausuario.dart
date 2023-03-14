import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/controllers/userController.dart';
import 'package:proyecto_integrador_3/user.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _obtenerUsuarios = ObtenerUsuarios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<User>>(
        future: _obtenerUsuarios.getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener los usuarios'));
          } else {
            final List<User> users = snapshot.data!;
            if (users.isEmpty) {
              return Center(child: Text('La lista de usuarios está vacía'));
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          '${user.name} ${user.lastname}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Teléfono: ${user.phone}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Email: ${user.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Contraseña Encriptada: ${user.password}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
