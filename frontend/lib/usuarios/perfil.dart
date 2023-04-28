import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/userController.dart';

class UserProfileEditor extends StatefulWidget {
  final String authToken;
  final String userEmail;
  late String _userEmail;

  UserProfileEditor({required this.authToken, required this.userEmail});

  @override
  _UserProfileEditorState createState() => _UserProfileEditorState();
}

class _UserProfileEditorState extends State<UserProfileEditor> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _isEditing = false;

  void _updateUserProfile() async {
    setState(() {
      _isEditing = true;
    });

    await UserEditor().editarUsuarioActual(
      widget.authToken,
      widget.userEmail,
      _nombreController.text,
      _apellidoController.text,
      _telefonoController.text,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', widget.userEmail);
    String? userEmail = prefs.getString('userEmail');

    setState(() {
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tu correo es:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.userEmail,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]+"))
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]+"))
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _isEditing
                  ? null
                  : () async {
                      _updateUserProfile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Perfil actualizado',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                textStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
              child: Text('Actualizar perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
