import 'package:flutter/material.dart';

import 'custom_drawer.dart';
import 'user.dart';

class ConductorPage extends StatefulWidget {
  final User user;
  const ConductorPage({Key? key, required this.user}) : super(key: key);

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
        drawer: CustomDrawer(profileName: "conductor", user: widget.user),
        body: const Center(
          child: Text('Vista del conductor'),
        ),
      ),
    );
  }
}
