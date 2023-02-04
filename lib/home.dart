// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, prefer_const_constructors

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Location _location = Location();
  late bool _permissionGranted;
  late geolocator.Position _currentPosition;
  final originController = TextEditingController();
  final destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  Future<void> _getPermission() async {
    _permissionGranted = (await _location.hasPermission()) as bool;
    if (_permissionGranted == false) {
      _permissionGranted = (await _location.requestPermission()) as bool;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAddress(String searchTerm) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$searchTerm&key=AIzaSyAv0rPS4ryGf6NcHoNas_VQbu5phAnAyXA';

    var response = await http.get(url as Uri);

    Map data = json.decode(response.body);

    String address = data['results'][0]['formatted_address'];

    print(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              width: MediaQuery.of(context).size.width,
              child: _currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        zoom: 17.0,
                      ),
                      myLocationEnabled: true,
                    )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      getAddress(value);
                    },
                    controller: originController,
                    decoration: InputDecoration(
                      hintText: "Origen",
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: "Destino",
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (value) {
                      getAddress(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
