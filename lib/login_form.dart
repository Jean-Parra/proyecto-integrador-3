// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/conductor.dart';
import 'package:proyecto_integrador_3/usuario.dart';
import 'package:proyecto_integrador_3/signup_form.dart';
import 'package:proyecto_integrador_3/database/mongo.dart';

import 'administrador.dart';
import 'olvido.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final MongoDB mongoDB = MongoDB();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 3.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Por favor ingrese un correo electrónico';
                }
                if (!input.contains('@')) {
                  return 'Por favor, introduce una dirección de correo electrónico válida';
                }
                return null;
              },
              onSaved: (input) => _email = input!,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Correo',
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Por favor ingrese una contraseña';
                }
                if (input.length < 6) {
                  return 'Su contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
              onSaved: (input) => _password = input!,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Contraseña',
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text(
                      'Inciar sesión',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            _errorMessage != null
                ? Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            TextButton(
              child: const Text('¿No tienes cuenta? Registrate',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (const SignupPage())));
              },
            ),
            TextButton(
              child: const Text('¿Olvidaste la contraseña?',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (const OlvidoPage())));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await mongoDB.connect();
        var validacion = await mongoDB.login(_email, _password);
        if (validacion?.type == "usuario") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (UsuarioPage(user: validacion!))));
        } else if (validacion?.type == "conductor") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (ConductorPage(user: validacion!))));
        } else if (validacion?.type == "administrador") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      (AdministradorPage(user: validacion!))));
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = "Credenciales invalidas";
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }
}
