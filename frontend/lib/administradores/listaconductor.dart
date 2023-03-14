import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/controllers/userController.dart';
import 'package:proyecto_integrador_3/user.dart';

class ListConductoresScreen extends StatefulWidget {
  @override
  _ListConductoresScreenState createState() => _ListConductoresScreenState();
}

class _ListConductoresScreenState extends State<ListConductoresScreen> {
  final _obtenerConductores = ObtenerConductores();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de conductores'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<User>>(
        future: _obtenerConductores.getConductores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener los conductores'));
          } else {
            final List<User> conductores = snapshot.data!;
            if (conductores.isEmpty) {
              return Center(child: Text('La lista de conductores está vacía'));
            }
            return ListView.builder(
              itemCount: conductores.length,
              itemBuilder: (context, index) {
                return ConductorListItem(conductor: conductores[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class ConductorListItem extends StatelessWidget {
  final User conductor;

  const ConductorListItem({Key? key, required this.conductor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          '${conductor.name} ${conductor.lastname}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Teléfono: ${conductor.phone}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Email: ${conductor.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Contraseña Encriptada: ${conductor.password}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
