// ignore_for_file: library_private_types_in_public_api, avoid_print

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
                        final smtpServer =
                            gmail('<smtp.gmail.com>', '<hqtavrwrbwiuiyxi>');
                        final message = Message()
                          ..from = const Address(
                              '<smtp.gmail.com>', 'Miguel Mendoza')
                          ..recipients.add(_emailController.text)
                          ..subject = 'Recuperación de contraseña'
                          ..text =
                              'Hola, ${user.name}. Tu código de recuperación de contraseña es: ${user.recoveryCode}. Por favor, ingresa este código en la app para cambiar tu contraseña.'
                          ..html =
                              '<p>Hola, ${user.name}.</p><p>Tu código de recuperación de contraseña es: ${user.recoveryCode}. Por favor, ingresa este código en la app para cambiar tu contraseña.</p>';
                        try {
                          await send(message, smtpServer);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Se ha enviado un correo de recuperación de contraseña.',
                              ),
                            ),
                          );
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
