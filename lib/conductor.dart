import 'package:flutter/material.dart';

class ConductorPage extends StatefulWidget {
  const ConductorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConductorPageState createState() => _ConductorPageState();
}

class _ConductorPageState extends State<ConductorPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conductor',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Conductor'),
        ),
        body: const Center(
          child: Text('Vista del conductor'),
        ),
      ),
    );
  }
}
