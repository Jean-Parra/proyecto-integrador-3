import 'package:flutter/material.dart';

class HistorialConductorPage extends StatelessWidget {
  HistorialConductorPage({super.key});

  // Ejemplo de datos de viajes
  final List<Map<String, dynamic>> _viajes = [
    {
      'fecha': '10 de Marzo, 2022',
      'origen': 'Piedecuesta',
      'destino': 'Bucaramanga',
      'costo': '\$15.000',
    },
    {
      'fecha': '15 de Marzo, 2022',
      'origen': 'Parque SanPio',
      'destino': 'UPB',
      'costo': '\$10.000',
    },
    {
      'fecha': '20 de Marzo, 2022',
      'origen': 'Floridablanca',
      'destino': 'Piedecuesta',
      'costo': '\$12.000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Historial',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Historial de viajes (CONDUCTOR)'),
        ),
        body: ListView.builder(
          itemCount: _viajes.length,
          itemBuilder: (context, index) {
            final viaje = _viajes[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(viaje['origen'] + ' - ' + viaje['destino']),
                subtitle: Text(viaje['fecha']),
                trailing: Text(
                  viaje['costo'],
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
