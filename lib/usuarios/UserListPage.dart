import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/database/mongo.dart';
import 'package:proyecto_integrador_3/user.dart';

class ListaUsuariosPage extends StatefulWidget {
  final List<User> users;
  const ListaUsuariosPage({Key? key, required this.users}) : super(key: key);

  @override
  _ListaUsuariosPageState createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  String _deleteReason = '';
  final db = MongoDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          final user = widget.users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${user.name} ${user.lastname}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email),
                  const SizedBox(height: 4),
                  Text('Tipo: ${user.type}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  _deleteReason = '';
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            '¿Está seguro de que desea eliminar este usuario?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Ingrese el motivo de la eliminación',
                                labelText: 'Motivo',
                              ),
                              onChanged: (value) {
                                _deleteReason = value;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await db
                                  .delete('usuarios', {'correo': user.email});
                              print('Su usuario es: $result');
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Usuario eliminado.')));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Ocurrió un error al eliminar al usuario. Intente de nuevo.')));
                              }
                            },
                            child: Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
