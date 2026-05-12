class LaunchModel {
  final String id;
  final String name;
  final String? flightNumber;
  final DateTime? dateUtc;
  final bool? success;
  final String? details;
  final String? rocket;
  final LaunchLinks? links;
  final bool? upcoming;
  final LaunchAgency? agency;
  final String? status;

  LaunchModel({
    required this.id,
    required this.name,
    this.flightNumber,
    this.dateUtc,
    this.success,
    this.details,
    this.rocket,
    this.links,
    this.upcoming,
    this.agency,
    this.status,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) {
  final isLaunchLibrary = json['launch_service_provider'] != null;

  // Safely extract image URL
  String? imageUrl;
  if (json['links']?['patch']?['small'] is String) {
    imageUrl = json['links']['patch']['small'];
  } else if (json['links']?['patch']?['large'] is String) {
    imageUrl = json['links']['patch']['large'];
  } else if (json['image'] is String) {
    imageUrl = json['image'];
  } else if (json['rocket']?['configuration']?['image_url'] is String) {
    imageUrl = json['rocket']['configuration']['image_url'];
  }

  return LaunchModel(
    id: json['id']?.toString() ?? '',
    name: json['name'] is String ? json['name'] : '',
    flightNumber: json['flight_number']?.toString(),
    dateUtc: json['date_utc'] != null
        ? DateTime.tryParse(json['date_utc'])
        : json['net'] != null
            ? DateTime.tryParse(json['net'])
            : null,
    success: json['success'] is bool ? json['success'] : null,
    details: json['details'] is String
        ? json['details']
        : (json['mission']?['description'] is String
            ? json['mission']['description']
            : ''),
    rocket: json['rocket'] is String
        ? json['rocket']
        : json['rocket']?['id']?.toString() ??
            (json['rocket']?['configuration']?['name'] is String
                ? json['rocket']['configuration']['name']
                : ''),
    links: LaunchLinks(
      patch: imageUrl != null ? Patch(small: imageUrl, large: imageUrl) : null,
      webcast: json['links']?['webcast'] is String
          ? json['links']['webcast']
          : json['webcast_live'] is String
              ? json['webcast_live']
              : (json['vid_urls'] is List && json['vid_urls'].isNotEmpty
                  ? json['vid_urls'][0]['url']
                  : null),
      article: json['links']?['article'] is String
          ? json['links']['article']
          : json['news_url'] is String
              ? json['news_url']
              : null,
      wikipedia: json['links']?['wikipedia'] is String
          ? json['links']['wikipedia']
          : json['infographic'] is String
              ? json['infographic']
              : null,
    ),
    upcoming: json['upcoming'] is bool ? json['upcoming'] : null,
    agency: isLaunchLibrary && json['launch_service_provider'] != null
        ? LaunchAgency.fromJson(json['launch_service_provider'])
        : null,
    status: json['status']?['name'] is String
        ? json['status']['name']
        : (json['status']?['abbrev'] is String
            ? json['status']['abbrev']
            : null),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'flight_number': flightNumber,
      'date_utc': dateUtc?.toIso8601String(),
      'success': success,
      'details': details,
      'rocket': rocket,
      'links': links?.toJson(),
      'upcoming': upcoming,
    };
  }
}

class LaunchAgency {
  final String name;
  final String? type;
  final String? countryCode;

  LaunchAgency({
    required this.name,
    this.type,
    this.countryCode,
  });

  factory LaunchAgency.fromJson(Map<String, dynamic> json) {
    return LaunchAgency(
      name: json['name'] ?? '',
      type: json['type'],
      countryCode: json['country_code'],
    );
  }
}

class LaunchLinks {
  final Patch? patch;
  final String? webcast;
  final String? article;
  final String? wikipedia;

  LaunchLinks({
    this.patch,
    this.webcast,
    this.article,
    this.wikipedia,
  });

  factory LaunchLinks.fromJson(Map<String, dynamic> json) {
    return LaunchLinks(
      patch: json['patch'] != null
          ? Patch.fromJson(json['patch'])
          : json['mission_patches'] != null && (json['mission_patches'] as List).isNotEmpty
              ? Patch(small: json['mission_patches'][0]['image_url'], large: json['mission_patches'][0]['image_url'])
              : json['image'] != null
                  ? Patch(small: json['image'], large: json['image'])
                  : null,
      webcast: json['webcast'] ?? json['webcast_live'] ?? json['vid_urls']?[0]?['url'],
      article: json['article'] ?? json['news_url'],
      wikipedia: json['wikipedia'] ?? json['infographic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patch': patch?.toJson(),
      'webcast': webcast,
      'article': article,
      'wikipedia': wikipedia,
    };
  }
}

class Patch {
  final String? small;
  final String? large;

  Patch({this.small, this.large});

  factory Patch.fromJson(Map<String, dynamic> json) {
    return Patch(
      small: json['small'] ?? json['image_url'],
      large: json['large'] ?? json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'large': large,
    };
  }
}