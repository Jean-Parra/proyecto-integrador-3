// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:polyline_do/polyline_do.dart' as polyline_do;

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
  geolocator.Position? _currentPosition;
  late GoogleMapController mapcontroller;

  late String _destination;
  final GoogleMapsDirections _directions =
      GoogleMapsDirections(apiKey: kGoogleApiKey);
  late String _origin;
  final Set<Polyline> _polylines = <Polyline>{};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Future<geolocator.Position> _getCurrentLocation() async {
    //Verificar si la ubicación del dispositivo está habilitada
    bool bGpsHabilitado =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!bGpsHabilitado) {
      return Future.error('Por favor habilite el servicio de ubicación.');
    }
    //Validar permiso para utilizar los servicios de localización
    geolocator.LocationPermission bGpsPermiso =
        await geolocator.Geolocator.checkPermission();
    if (bGpsPermiso == geolocator.LocationPermission.denied) {
      bGpsPermiso = await geolocator.Geolocator.requestPermission();
      if (bGpsPermiso == geolocator.LocationPermission.denied) {
        return Future.error('Se denegó el permiso para obtener la ubicación.');
      }
    }
    if (bGpsPermiso == geolocator.LocationPermission.deniedForever) {
      return Future.error(
          'Se denegó el permiso para obtener la ubicación de forma permanente.');
    }
    //En este punto los permisos están habilitados y se puede consultar la ubicación
    return await geolocator.Geolocator.getCurrentPosition();
  }

  Future<void> _showRoute() async {
    try {
      final origin = await geocoding.locationFromAddress(_origin,
          localeIdentifier: "es_ES");
      final destination = await geocoding.locationFromAddress(_destination,
          localeIdentifier: "es_ES");

      final originLocation =
          Location(lat: origin[0].latitude, lng: origin[0].longitude);
      print("ORIGEN ACA $originLocation");
      final destinationLocation =
          Location(lat: destination[0].latitude, lng: destination[0].longitude);
      print(destinationLocation);

      final result = await _directions.directionsWithLocation(
        originLocation,
        destinationLocation,
        travelMode: TravelMode.driving,
      );

      final points = polyline_do.Polyline.Decode(
        precision: 5,
        encodedString: result.routes[0].overviewPolyline.points,
      );
      print(points);
      setState(() {
        _polylines.add(points as Polyline);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error al trazar la ruta"),
          content: const Text(
              "No se pudo trazar la ruta. Verifica que la dirección de origen y destino sean válidas y que tengas una conexión a internet."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
                      target: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      zoom: 17.0,
                    ),
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      mapcontroller = controller;
                    },
                    polylines: _polylines,
                  ),
          ),
        ],
      ),
    );
  }
}
