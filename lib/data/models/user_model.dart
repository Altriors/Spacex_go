class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final List<String> favoriteLaunches;
  final bool notificationsEnabled;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.favoriteLaunches = const [],
    this.notificationsEnabled = true,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      favoriteLaunches: json['favoriteLaunches'] != null
          ? List<String>.from(json['favoriteLaunches'])
          : [],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'favoriteLaunches': favoriteLaunches,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    List<String>? favoriteLaunches,
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteLaunches: favoriteLaunches ?? this.favoriteLaunches,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}