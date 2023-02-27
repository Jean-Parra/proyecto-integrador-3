// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Polyline;
import 'package:location/location.dart' as location;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:polyline_do/polyline_do.dart' as polyline_do;
import 'package:permission_handler/permission_handler.dart';

import 'package:proyecto_integrador_3/custom_drawer.dart';
import 'package:proyecto_integrador_3/user.dart';

const kGoogleApiKey = "AIzaSyAv0rPS4ryGf6NcHoNas_VQbu5phAnAyXA";

class UsuarioPage extends StatefulWidget {
  final User user;
  const UsuarioPage({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  late geolocator.Position _currentPosition;
  late GoogleMapController mapcontroller;

  late String _destination;
  final GoogleMapsDirections _directions =
      GoogleMapsDirections(apiKey: kGoogleApiKey);

  final location.Location _location = location.Location();
  late String _origin;
  late bool _permissionGranted = false;
  final Set<polyline_do.Polyline> _polylines = <polyline_do.Polyline>{};

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  Future<void> _getPermission() async {
    final permissionResult = await _location.requestPermission();
    _permissionGranted = permissionResult == PermissionStatus.granted;
    if (!_permissionGranted) {
      final permissionResult = await _location.requestPermission();
      _permissionGranted = permissionResult == PermissionStatus.granted;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final posicion = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      setState(() {
        _currentPosition = posicion;
      });
    } catch (e) {
      print(e);
    }
  }

/*  Future<void> _showRoute() async {
    try {
      final origin = await geocoding.locationFromAddress(_origin,
          localeIdentifier: "es_ES");
      final destination = await geocoding.locationFromAddress(_destination,
          localeIdentifier: "es_ES");

      final originLocation =
          Location(lat: origin[0].latitude, lng: origin[0].longitude);
      final destinationLocation =
          Location(lat: destination[0].latitude, lng: destination[0].longitude);

      final result = await _directions.directionsWithLocation(
        originLocation,
        destinationLocation,
      );

      final points = polyline_do.Polyline.Decode(
        precision: 1,
        encodedString: result.routes[0].overviewPolyline.points,
      );
      setState(() {
        _polylines.add(points);
      });
    } catch (e) {
      print(e);
    }
  } */

  Future<void> _showRoute() async {
    try {
      final origin = await geocoding.locationFromAddress(_origin,
          localeIdentifier: "es_ES");
      final destination = await geocoding.locationFromAddress(_destination,
          localeIdentifier: "es_ES");

      final originLocation =
          Location(lat: origin[0].latitude, lng: origin[0].longitude);
      final destinationLocation =
          Location(lat: destination[0].latitude, lng: destination[0].longitude);

      const mode = TravelMode.driving;

      final result = await _directions.directionsWithLocation(
        originLocation,
        destinationLocation,
        travelMode: TravelMode.driving,
      );

      final points = polyline_do.Polyline.Decode(
        precision: 5,
        encodedString: result.routes[0].overviewPolyline.points,
      );
      setState(() {
        _polylines.add(points);
      });
    } catch (e) {
      print(e);
      print("RECIBIDO");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuario'),
      ),
      drawer: CustomDrawer(profileName: "usuario", user: widget.user),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
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
                    decoration: const InputDecoration(
                      hintText: "Origen",
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _origin = value;
                      });
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Destino",
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _destination = value;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  child: const Text('Trazar camino'),
                  onPressed: () {
                    _showRoute();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 230,
            width: MediaQuery.of(context).size.width,
            // ignore: unnecessary_null_comparison
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition.latitude,
                          _currentPosition.longitude),
                      zoom: 17.0,
                    ),
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      mapcontroller = controller;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
