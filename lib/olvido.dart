import 'package:flutter/material.dart';

import 'database/mongo.dart';

class OlvidoPage extends StatefulWidget {
  const OlvidoPage({Key? key}) : super(key: key);

  @override
  _OlvidoPageState createState() => _OlvidoPageState();
}

class _OlvidoPageState extends State<OlvidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _mongoDB = MongoDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              const Text(
                'Ingresa tu correo electrónico',
                style: TextStyle(fontSize: 16.0),
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  // TODO: validar que el correo existe en la base de datos
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: enviar correo de recuperación de contraseña
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Se ha enviado un correo de recuperación de contraseña.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Recuperar contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
