class ShipModel {
  final String id;
  final String? name;
  final String? type;
  final bool? active;
  final String? homePort;
  final String? image;
  final List<String>? launches;

  ShipModel({
    required this.id,
    this.name,
    this.type,
    this.active,
    this.homePort,
    this.image,
    this.launches,
  });

  factory ShipModel.fromJson(Map<String, dynamic> json) {
    return ShipModel(
      id: json['id'] ?? '',
      name: json['name'],
      type: json['type'],
      active: json['active'],
      homePort: json['home_port'],
      image: json['image'],
      launches: json['launches'] != null ? List<String>.from(json['launches']) : null,
    );
  }
}