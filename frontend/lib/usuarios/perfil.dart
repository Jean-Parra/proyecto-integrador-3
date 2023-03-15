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
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _lastname;
  late String _email;
  late String _telefono;

  @override
  void initState() {
    super.initState();
    _userFuture = UserActual.getUsuarioActual(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User user = snapshot.data!;
            _nombre = user.name;
            _email = user.email;
            _telefono = user.phone;
            return Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      initialValue: user.name,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su nombre';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nombre = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user.email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user.phone,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su teléfono';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _telefono = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            EditingUser.editarUsuarioActual(
                              widget.userId,
                              _nombre,
                              _email,
                              _telefono,
                            );
                            Get.snackbar(
                              'Perfil actualizado',
                              'El perfil ha sido actualizado exitosamente',
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error al actualizar el perfil',
                            e.toString(),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el usuario: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
