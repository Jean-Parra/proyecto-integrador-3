class Solicitud {
  final String id;
  final String email;
  final String origin;
  final String destination;
  final double distance;
  final int price;
  final String selectedOption;

  Solicitud({
    required this.id,
    required this.email,
    required this.origin,
    required this.destination,
    required this.distance,
    required this.price,
    required this.selectedOption,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['_id'],
      email: json['email'],
      origin: json['origin'],
      destination: json['destination'],
      distance: json['distance'].toDouble(),
      price: json['price'],
      selectedOption: json['selectedOption'],
    );
  }
}
