// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:proyecto_integrador_3/controllers/routeController.dart';
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
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  GoogleMapController? mapController;
  double? _distance;
  int? _price;
  final GuardarViaje _viaje = GuardarViaje();

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(
            title: 'Center',
            snippet: 'The center of the map',
          ),
        ),
      );
    });
  }

  Future<void> getRoutePoints() async {
    String origin = Uri.encodeComponent(originController.text);
    print(origin);
    String destination = Uri.encodeComponent(destinationController.text);
    print(destination);
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$kGoogleApiKey";
    print(url);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      print(data['status']);
      if (data['status'] == 'OK') {
        print("hola");
        var startLocation = data['routes'][0]['legs'][0]['start_location'];
        var endLocation = data['routes'][0]['legs'][0]['end_location'];
        var points = data['routes'][0]['overview_polyline']['points'];
        var routePoints = PolylinePoints().decodePolyline(points);
        setState(() {
          _markers.clear();
          _polylines.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('id-2'),
              position: LatLng(startLocation['lat'], startLocation['lng']),
              infoWindow: InfoWindow(
                title: 'Origin',
                snippet: origin,
              ),
            ),
          );
          _markers.add(
            Marker(
              markerId: const MarkerId('id-3'),
              position: LatLng(endLocation['lat'], endLocation['lng']),
              infoWindow: InfoWindow(
                title: 'Destination',
                snippet: destination,
              ),
            ),
          );
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('id-4'),
              color: Colors.blue,
              width: 5,
              points: routePoints
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            ),
          );
          double distance =
              data['routes'][0]['legs'][0]['distance']['value'] / 1000.0;
          int basePrice = 5000;
          double additionalPrice = max(0, distance - 2.0) * 500.0;
          double price = basePrice + additionalPrice;
          int roundedPrice = (price / 50.0).ceil() * 50;

          print('El precio es de \$${roundedPrice.toString()}');
          _distance = distance;
          _price = roundedPrice.toInt();
        });
      } else {
        print("chao");
      }
    } else {
      print("el estado no es 200");
    }
  }

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
                        originController.text = value;
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
                        destinationController.text = value;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  child: const Text('Trazar camino'),
                  onPressed: () async {
                    getRoutePoints();
                    await showDialog(
                        context: context,
                        builder: (context) {
                          String selectedOption = 'efectivo';
                          return AlertDialog(
                            title: Text(
                                'La distancia es: $_distance KM\nEl precio es: $_price COP'),
                            content: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.money),
                                        SizedBox(width: 10),
                                        Text('Efectivo'),
                                      ],
                                    ),
                                    value: 'efectivo',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.credit_card),
                                        SizedBox(width: 10),
                                        Text('Tarjeta'),
                                      ],
                                    ),
                                    value: 'tarjeta',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  print(widget.user.email);
                                  await _viaje.saveViaje(
                                      widget.user.email,
                                      originController.text,
                                      destinationController.text,
                                      _distance!,
                                      _price!,
                                      selectedOption);
                                  Navigator.pop(context);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        });
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
                    markers: _markers,
                    polylines: _polylines,
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,
                    rotateGesturesEnabled: true,
                    onMapCreated: _onMapCreated),
          ),
        ],
      ),
    );
  }
}
