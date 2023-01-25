// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_field, unrelated_type_equality_checks, avoid_print

import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/database/mongo.dart';
import 'package:proyecto_integrador_3/login_form.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _passwordValue = "";
  final _formKey = GlobalKey<FormState>();
  final MongoDB mongoDB = MongoDB();
  var _name = TextEditingController();
  var _lastname = TextEditingController();
  var _number = TextEditingController();
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();
  final Map<String, dynamic> _data = {};
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    mongoDB.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _name,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (input) => _name = input as TextEditingController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) => {_data['nombre'] = value},
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese un apellido';
                  }
                  return null;
                },
                onSaved: (input) => _lastname = input as TextEditingController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Apellido',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) => {_data['apellido'] = value},
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese un número de teléfono';
                  }
                  return null;
                },
                onSaved: (input) => _number = input as TextEditingController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Número de teléfono',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) => {_data['telefono'] = value},
                style: const TextStyle(color: Colors.black),
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
                onSaved: (input) => _email = input as TextEditingController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Correo',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) => {_data['correo'] = value},
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
                onSaved: (input) => _password = input as TextEditingController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) =>
                    {_data['contraseña'] = value, _passwordValue = value},
                obscureText: true,
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
                  if (input != _passwordValue) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
                onSaved: (input) =>
                    _confirmPassword = input as TextEditingController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Confirmar contraseña',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
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
                        'Crear cuenta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              _errorMessage != null
                  ? Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    )
                  : Container(),
              TextButton(
                child: const Text('¿Ya tienes cuenta? iniciar sesión',
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (const LoginPage())));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    print(_data);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await mongoDB.connect();
        await mongoDB.insert('usuarios', _data);
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }
}
