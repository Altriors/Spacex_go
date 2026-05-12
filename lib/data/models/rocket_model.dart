class RocketModel {
  final String id;
  final String name;
  final String type;
  final bool? active;
  final int? stages;
  final int? boosters;
  final double? costPerLaunch;
  final double? successRatePct;
  final String? firstFlight;
  final String? country;
  final String? company;
  final String? description;
  final RocketHeight? height;
  final RocketDiameter? diameter;
  final RocketMass? mass;
  final List<String>? flickrImages;

  RocketModel({
    required this.id,
    required this.name,
    required this.type,
    this.active,
    this.stages,
    this.boosters,
    this.costPerLaunch,
    this.successRatePct,
    this.firstFlight,
    this.country,
    this.company,
    this.description,
    this.height,
    this.diameter,
    this.mass,
    this.flickrImages,
  });

  factory RocketModel.fromJson(Map<String, dynamic> json) {
    final isLaunchLibrary = json['full_name'] != null;

    // Parse height
    RocketHeight? height;
    if (json['height'] != null) {
      height = RocketHeight.fromJson(json['height']);
    } else if (json['length'] != null) {
      height = RocketHeight(
        meters: json['length']?.toDouble(),
        feet: json['length'] != null
            ? (json['length'] * 3.28084).toDouble()
            : null,
      );
    }

    // Parse mass
    RocketMass? mass;
    if (json['mass'] != null) {
      mass = RocketMass.fromJson(json['mass']);
    } else if (json['launch_mass'] != null) {
      mass = RocketMass(
        kg: json['launch_mass'],
        lb: json['launch_mass'] != null
            ? (json['launch_mass'] * 2.20462).toInt()
            : null,
      );
    } else if (json['leo_capacity'] != null) {
      mass = RocketMass(
        kg: json['leo_capacity'],
        lb: json['leo_capacity'] != null
            ? (json['leo_capacity'] * 2.20462).toInt()
            : null,
      );
    }

    // Parse success rate
    double? successRate;
    if (json['success_rate_pct'] != null) {
      successRate = json['success_rate_pct']?.toDouble();
    } else if (json['successful_launches'] != null &&
        json['total_launch_count'] != null &&
        json['total_launch_count'] > 0) {
      successRate = (json['successful_launches'] /
              json['total_launch_count'] *
              100)
          .toDouble();
    }

    return RocketModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      type: json['type'] ?? json['family'] ?? json['variant'] ?? 'Unknown',
      active: json['active'],
      stages: json['stages'],
      boosters: json['boosters'],
      costPerLaunch: json['cost_per_launch']?.toDouble(),
      successRatePct: successRate,
      firstFlight: json['first_flight'] ?? json['maiden_flight'],
      country: json['country'],
      company: json['company'] ??
          json['manufacturer']?['name'] ??
          json['launch_service_provider']?['name'],
      description: json['description'],
      height: height,
      diameter: json['diameter'] != null
          ? RocketDiameter.fromJson(json['diameter'])
          : null,
      mass: mass,
      flickrImages: json['flickr_images'] != null
          ? List<String>.from(json['flickr_images'])
          : json['image_url'] != null
              ? [json['image_url']]
              : json['program'] != null &&
                      json['program'].isNotEmpty &&
                      json['program'][0]['image_url'] != null
                  ? [json['program'][0]['image_url']]
                  : null,
    );
  }
}

class RocketHeight {
  final double? meters;
  final double? feet;

  RocketHeight({this.meters, this.feet});

  factory RocketHeight.fromJson(Map<String, dynamic> json) {
    return RocketHeight(
      meters: json['meters']?.toDouble(),
      feet: json['feet']?.toDouble(),
    );
  }
}

class RocketDiameter {
  final double? meters;
  final double? feet;

  RocketDiameter({this.meters, this.feet});

  factory RocketDiameter.fromJson(Map<String, dynamic> json) {
    return RocketDiameter(
      meters: json['meters']?.toDouble(),
      feet: json['feet']?.toDouble(),
    );
  }
}

class RocketMass {
  final int? kg;
  final int? lb;

  RocketMass({this.kg, this.lb});

  factory RocketMass.fromJson(Map<String, dynamic> json) {
    return RocketMass(
      kg: json['kg'],
      lb: json['lb'],
    );
  }
}
