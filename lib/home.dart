// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Polyline;
import 'package:location/location.dart' as location;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:geocoding/geocoding.dart' as nueva;
import 'package:polyline_do/polyline_do.dart' as polyline_do;

const kGoogleApiKey = "AIzaSyAv0rPS4ryGf6NcHoNas_VQbu5phAnAyXA";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late geolocator.Position _currentPosition;
  late String _destination;
  final GoogleMapsDirections _directions =
      GoogleMapsDirections(apiKey: kGoogleApiKey);

  final location.Location _location = location.Location();
  late String _origin;
  late bool _permissionGranted;
  final Set<polyline_do.Polyline> _polylines = <polyline_do.Polyline>{};

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  Future<void> _getPermission() async {
    _permissionGranted = (await _location.requestPermission()) as bool;
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

  Future<void> _showRoute() async {
    try {
      final origin =
          await nueva.locationFromAddress(_origin, localeIdentifier: "es_ES");
      final destination = await nueva.locationFromAddress(_destination,
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
        precision: 5,
        encodedString: result.routes[0].overviewPolyline.points,
      );
      setState(() {
        _polylines.add(points);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: MediaQuery.of(context).size.height - 150,
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
                    onMapCreated: (GoogleMapController controller) {},
                  ),
          ),
        ],
      ),
    );
  }
}
