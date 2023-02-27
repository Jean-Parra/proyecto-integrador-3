import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/database/mongo.dart';
import 'package:proyecto_integrador_3/user.dart';

class ListaUsuariosPage extends StatefulWidget {
  @override
  _ListaUsuariosPageState createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  List<User> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  void _cargarUsuarios() async {
    final db = MongoDB();
    await db.connect();
    final usuarios = await db.find("usuarios", {});
    final mapped = usuarios.map((e) => User.fromMap(e)).toList().cast<User>();
    setState(() {
      _usuarios = mapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuarios"),
      ),
      body: ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (BuildContext context, int index) {
          final usuario = _usuarios[index];
          return ListTile(
            title: Text(usuario.name),
            subtitle: Text(usuario.email),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _mostrarDialogoEliminar(usuario);
              },
            ),
          );
        },
      ),
    );
  }

  void _mostrarDialogoEliminar(User usuario) {
    String motivoEliminacion = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar usuario'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '¿Está seguro que desea eliminar al usuario ${usuario.name}?'),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Motivo de eliminación',
                    hintText: 'Ingrese el motivo de eliminación',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    motivoEliminacion = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                final db = MongoDB();
                await db.connect();
                await db.delete(
                  "usuarios",
                  {"correo": usuario.email},
                );
                await db.close();

                Navigator.of(context).pop();
                setState(() {
                  _usuarios.remove(usuario);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Usuario eliminado'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
