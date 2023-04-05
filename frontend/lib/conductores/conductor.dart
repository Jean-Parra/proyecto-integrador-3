// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:proyecto_integrador_3/custom_drawer.dart';
import 'package:proyecto_integrador_3/Models/user.dart';

import '../Models/solicitudes.dart';
import '../controllers/routeController.dart';

class ConductorPage extends StatefulWidget {
  final User user;
  const ConductorPage({Key? key, required this.user}) : super(key: key);

  @override
  ConductorPageState createState() => ConductorPageState();
}

class ConductorPageState extends State<ConductorPage> {
  bool _activo = false;
  final MostrarSolicitudes _obtenerSolicitudes = MostrarSolicitudes();
  final GuardarViajes _viaje = GuardarViajes();
  List<Solicitud> _solicitudes = [];
  Future<List<Solicitud>>? _futureSolicitudes;

  @override
  void initState() {
    super.initState();
    _futureSolicitudes = _obtenerSolicitudes.fetchSolicitudes();
  }

  void _rechazarSolicitud(Solicitud solicitud) {
    setState(() {
      _solicitudes.remove(solicitud);
    });
    print('Solicitud rechazada: ${solicitud.id}');
  }

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
            _activo
                ? FutureBuilder<List<Solicitud>>(
                    future: _futureSolicitudes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _solicitudes = snapshot.data!;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: _solicitudes.length,
                            itemBuilder: (context, index) {
                              final solicitud = _solicitudes[index];
                              return Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Email:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            solicitud.email,
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Text(
                                            'Origen:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            solicitud.origin,
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Text(
                                            'Destino:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            solicitud.destination,
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Text(
                                            'Distancia:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            '${solicitud.distance} km',
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Text(
                                            'Precio:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            solicitud.price.toString(),
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Text(
                                            'Opción seleccionada:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            solicitud.selectedOption,
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                _viaje.aceptarSolicitud(
                                                    widget.user.email,
                                                    solicitud.email,
                                                    solicitud.origin,
                                                    solicitud.destination,
                                                    solicitud.distance,
                                                    solicitud.price,
                                                    solicitud.selectedOption),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text('Aceptar'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () =>
                                                _rechazarSolicitud(solicitud),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('Rechazar'),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
