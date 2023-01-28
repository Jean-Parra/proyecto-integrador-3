// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_field, unrelated_type_equality_checks, avoid_print

import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/database/mongo.dart';
import 'package:proyecto_integrador_3/home.dart';
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
  TextEditingController? _name;
  TextEditingController? _lastname;
  TextEditingController? _number;
  TextEditingController? _email;
  TextEditingController? _password;
  TextEditingController? _confirmPassword;
  final Map<String, dynamic> _data = {};
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
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
                controller: _lastname,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese un apellido';
                  }
                  return null;
                },
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
                controller: _number,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese un número de teléfono';
                  }
                  return null;
                },
                onSaved: (newValue) => _number,
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
                controller: _email,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese un correo electrónico';
                  }
                  if (!input.contains('@')) {
                    return 'Por favor, introduce una dirección de correo electrónico válida';
                  }
                  return null;
                },
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
                controller: _password,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  if (input.length < 6) {
                    return 'Su contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
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
                controller: _confirmPassword,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  if (input != _passwordValue) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await mongoDB.connect();
        await mongoDB.insert('usuarios', _data);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => (const HomePage())));
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }
}
