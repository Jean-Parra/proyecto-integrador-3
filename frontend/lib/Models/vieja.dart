class Viaje {
  final String id;
  final String usuario;
  final String conductor;
  final String origin;
  final String destination;
  final double distance;
  final int price;
  final String selectedOption;

  Viaje({
    required this.id,
    required this.usuario,
    required this.conductor,
    required this.origin,
    required this.destination,
    required this.distance,
    required this.price,
    required this.selectedOption,
  });

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['_id'],
      usuario: json['email'],
      conductor: json['conductor'],
      origin: json['origin'],
      destination: json['destination'],
      distance: json['distance'].toDouble(),
      price: json['price'],
      selectedOption: json['selectedOption'],
    );
  }
}
