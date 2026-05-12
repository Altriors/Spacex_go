class CapsuleModel {
  final String id;
  final String? serial;
  final String? status;
  final String? type;
  final int? reuseCount;
  final int? waterLandings;
  final int? landLandings;
  final String? lastUpdate;
  final List<String>? launches;

  CapsuleModel({
    required this.id,
    this.serial,
    this.status,
    this.type,
    this.reuseCount,
    this.waterLandings,
    this.landLandings,
    this.lastUpdate,
    this.launches,
  });

  factory CapsuleModel.fromJson(Map<String, dynamic> json) {
    return CapsuleModel(
      id: json['id'] ?? '',
      serial: json['serial'],
      status: json['status'],
      type: json['type'],
      reuseCount: json['reuse_count'],
      waterLandings: json['water_landings'],
      landLandings: json['land_landings'],
      lastUpdate: json['last_update'],
      launches: json['launches'] != null ? List<String>.from(json['launches']) : null,
    );
  }
}