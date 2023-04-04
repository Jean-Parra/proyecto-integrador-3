import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/custom_drawer.dart';
import 'package:proyecto_integrador_3/user.dart';

class ConductorPage extends StatefulWidget {
  final User user;
  const ConductorPage({Key? key, required this.user}) : super(key: key);

  @override
  ConductorPageState createState() => ConductorPageState();
}

class ConductorPageState extends State<ConductorPage> {
  bool _activo = false;

  void _toggleActivo() {
    setState(() {
      _activo = !_activo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor'),
      ),
      drawer: CustomDrawer(profileName: "conductor", user: widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Estado: ${_activo ? 'Activo' : 'Inactivo'}',
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _toggleActivo(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _activo ? Colors.red : Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: Text(_activo ? 'Inactivo' : 'Activo'),
            ),
          ],
        ),
      ),
    );
  }
}
