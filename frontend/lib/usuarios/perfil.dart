import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// ignore: depend_on_referenced_packages
import '../user.dart';
// ignore: depend_on_referenced_packages
import '../controllers/userController.dart';

class PerfilUsuarioPage extends StatefulWidget {
  final String userId;
  const PerfilUsuarioPage({required this.userId, Key? key}) : super(key: key);

  @override
  _PerfilUsuarioPageState createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    final UserController userController = Get.find<UserController>();
    _userFuture = UserActual().getUsuarioActual(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final User user = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombres: ${user.name}'),
                    Text('Apellidos: ${user.lastname}'),
                    Text('Celular: ${user.phone}'),
                    Text('Email: ${user.email}'),
                    Text('Rol: ${user.role}'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
