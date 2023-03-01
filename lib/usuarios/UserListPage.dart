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
              subtitle: Text(user.email),
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
                              final result = await MongoDB()
                                  .delete('usuarios', {'correo': user.email});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Usuario eliminado.')),
                              );
                              Navigator.pop(context);
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
