// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'controllers/userController.dart';
import 'package:proyecto_integrador_3/signup_form.dart';
import 'olvido.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final LoginController _loginController = LoginController();

  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
            _loginController.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            _loginController.errorMessage != ""
                ? Text(
                    _loginController.errorMessage,
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
                        builder: (context) => const OlvidoPage()));
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
        _loginController.isLoading = true;
        _loginController.errorMessage = "";
      });
      try {
        await _loginController.signIn(_email, _password);

        // Agregar estas líneas para guardar el correo electrónico en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('driverEmail', _email);
        await prefs.setString('userEmail', _email);
        await prefs.setString('userEdit', _email);

        String? driverEmail = prefs.getString('driverEmail');
        String? userEmail = prefs.getString('userEmail');
        String? userEdit = prefs.getString('userEdit');
        print('Su correo es: $driverEmail');
      } catch (e) {
        setState(() {
          _loginController.isLoading = false;
          _loginController.errorMessage = e.toString();
        });
      }
      setState(() {
        _loginController.isLoading = false;
      });
    }
  }
}
