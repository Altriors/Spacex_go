class AppConstants {
  static const String appName = 'SpaceX GO';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyFavorites = 'favorites';
  static const String keyNotifications = 'notifications_enabled';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
}