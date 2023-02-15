import 'package:flutter/material.dart';

class OlvidoPage extends StatefulWidget {
  const OlvidoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OlvidoPageState createState() => _OlvidoPageState();
}

class _OlvidoPageState extends State<OlvidoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olvido',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Olvido'),
        ),
        body: const Center(
          child: Text('Vista del Olvido'),
        ),
      ),
    );
  }
}
