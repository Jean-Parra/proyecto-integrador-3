// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
  String _recoveryCode = '';

  @override
  void dispose() {
    _emailController.dispose(); // liberar el controlador del correo electrónico
    super.dispose();
  }

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
                  if (!RegExp(r"^[a-zA-Z0-9+.-]+@[a-zA-Z0-9.-]+$")
                      .hasMatch(value)) {
                    return 'Por favor ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user =
                          await _mongoDB.getUserByEmail(_emailController.text);
                      if (user != null) {
                        final smtpServer = SmtpServer('smtp.office365.com',
                            username: 'mateito8001@hotmail.com',
                            password: 'Lolmiamor2211');
                        final randomCode = Random().nextInt(900000) +
                            100000; // Genera un código aleatorio de 6 dígitos
                        final message = Message()
                          ..from = const Address(
                              'mateito8001@hotmail.com', 'Administrador')
                          ..recipients.add(_emailController.text)
                          ..subject = 'Recuperación de contraseña'
                          ..text =
                              'Hola, ${user.name}. Tu código de recuperación de contraseña es: $randomCode. Por favor, ingresa este código en la app para cambiar tu contraseña.'
                          ..html =
                              '<p>Hola, ${user.name}.</p><p>Tu código de recuperación de contraseña es: $randomCode. Por favor, ingresa este código en la app para cambiar tu contraseña.</p>';
                        try {
                          await send(message, smtpServer);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Se ha enviado un correo de recuperación de contraseña a tu dirección de email. Por favor, sigue las instrucciones en el correo para cambiar tu contraseña.',
                              ),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          final newPasswordAndCode =
                              // ignore: use_build_context_synchronously
                              await showDialog<Map<String, String>>(
                            context: context,
                            builder: (BuildContext context) {
                              final codeController = TextEditingController();
                              final passwordController =
                                  TextEditingController();
                              return AlertDialog(
                                title: const Text('Cambiar contraseña'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: codeController,
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Ingresa el código de recuperación',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, ingresa el código de recuperación que recibiste en tu correo';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: 'Ingresa tu nueva contraseña',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, ingresa tu nueva contraseña';
                                        }
                                        if (value.length < 6) {
                                          return 'La contraseña debe tener al menos 6 caracteres';
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (codeController.text.isNotEmpty &&
                                          passwordController.text.isNotEmpty &&
                                          passwordController.text.length >= 6) {
                                        final user =
                                            await _mongoDB.getUserByEmail(
                                                _emailController.text);
                                        final code =
                                            int.tryParse(codeController.text) ??
                                                0;
                                        if (user != null &&
                                            code == randomCode) {
                                          await _mongoDB.updatePassword(
                                              user.email,
                                              passwordController.text);
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'La contraseña se ha actualizado correctamente.',
                                              ),
                                            ),
                                          );
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                'El código de recuperación que ingresaste no es válido. Por favor, verifica tus datos e inténtalo de nuevo.',
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Guardar'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (newPasswordAndCode != null &&
                              newPasswordAndCode['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  newPasswordAndCode['message']!,
                                ),
                              ),
                            );
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'La contraseña se ha actualizado correctamente.',
                                ),
                              ),
                            );
                          }
                        } on MailerException catch (e) {
                          print('Error al enviar correo: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ocurrió un error al enviar el correo de recuperación de contraseña. Por favor, inténtalo de nuevo más tarde.',
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se encontró un usuario registrado con el correo electrónico proporcionado. Por favor, verifica tus datos e inténtalo de nuevo.',
                            ),
                          ),
                        );
                      }
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
