class ApiConstants {
  // Base URLs
  static const String baseUrlLaunchLibrary = 'https://ll.thespacedevs.com/2.2.0';
  static const String baseUrlSpaceX = 'https://api.spacexdata.com/v4';

  // 🚀 Launch Library 2 API
  static const String launches = '$baseUrlLaunchLibrary/launch';
  static const String launchesUpcoming = '$baseUrlLaunchLibrary/launch/upcoming';
  static const String launchesPast = '$baseUrlLaunchLibrary/launch/previous';
  static const String launchesLatest = '$baseUrlLaunchLibrary/launch/latest';
  static const String launchesNext = '$baseUrlLaunchLibrary/launch/upcoming';

  // 🛰️ Rockets (SpaceX)
  static const String rockets = '$baseUrlSpaceX/rockets';
  static const String spacexRockets = '$baseUrlSpaceX/rockets';
  

  // 🌍 Agencies
  static const String agencies = '$baseUrlLaunchLibrary/agencies';

  // 🔧 Default query
  static const Map<String, dynamic> defaultQuery = {
    'limit': 20,
    'offset': 0,
  };
}
