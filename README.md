# SpaceX GO

A comprehensive Flutter application for tracking SpaceX launches, vehicles, and company information. Built with Firebase integration for user management and real-time data synchronization.

## Overview

SpaceX GO provides users with detailed information about past and upcoming SpaceX launches, along with comprehensive data about the company's fleet of rockets, ships, and capsules. The application leverages the SpaceX API to deliver real-time updates and historical data in an intuitive mobile interface.

## Features

### Launch Tracking
- Browse comprehensive lists of past and upcoming launches
- View detailed information for each mission including success status, payload details, and launch site
- Real-time countdown timers for upcoming launches
- Filter and search functionality for easy navigation
- Access to mission patches, webcast links, and related articles

### Vehicle Information
- Complete portfolio of SpaceX rockets with technical specifications
- Real-time tracking of active ships including position and status data
- Detailed information about Dragon capsules and their flight history
- High-resolution images and detailed specifications for each vehicle
- Performance metrics including success rates and operational statistics

### Notifications
- Customizable launch notifications with configurable timing options
- Push notifications before scheduled launches
- Support for multiple notification intervals (1 hour, 1 day, 1 week before launch)
- Firebase Cloud Messaging integration for reliable delivery

### User Features
- Secure authentication with email and password
- Personal favorites system for launches and vehicles
- User profiles with customizable preferences
- Cross-device synchronization through Firebase
- Dark and light theme support

## Technology Stack

### Frontend
- Flutter SDK
- Provider for state management
- Material Design components

### Backend Services
- Firebase Authentication for user management
- Cloud Firestore for data storage
- Firebase Cloud Messaging for notifications
- SpaceX API v4 for launch and vehicle data

### Key Dependencies
- firebase_core and firebase_auth for authentication
- cloud_firestore for database operations
- dio for HTTP requests
- provider for state management
- flutter_local_notifications for local notifications
- cached_network_image for optimized image loading
- intl for internationalization and date formatting

## Project Structure
spacex_go/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── utils/
│   │   └── theme/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   ├── presentation/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   └── routes/
├── assets/
├── android/
├── ios/
└── test/


## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Firebase account for backend services
- Git for version control

### Installation Steps

1. Clone the repository
```bash
git clone https://github.com/yourusername/spacex_go.git
cd spacex_go
```

2. Install dependencies
```bash
flutter pub get
```

3. Firebase Configuration
   - Create a new Firebase project at console.firebase.google.com
   - Add an Android and/or iOS app to your Firebase project
   - Download the configuration files:
     - google-services.json for Android (place in android/app/)
     - GoogleService-Info.plist for iOS (place in ios/Runner/)
   - Enable Email/Password authentication in Firebase Console
   - Create a Cloud Firestore database in test mode
   - Enable Firebase Cloud Messaging

4. Configure Firebase in Flutter
```bash
flutterfire configure
```

5. Run the application
```bash
flutter run
```

## API Integration

This application uses the SpaceX API v4 for accessing launch and vehicle data.

Base URL: https://api.spacexdata.com/v4/

### Primary Endpoints Used
- /launches - All launches data
- /launches/upcoming - Future scheduled launches
- /launches/past - Historical launch data
- /rockets - Rocket specifications and details
- /ships - Active and inactive ship information
- /capsules - Dragon capsule fleet data
- /company - SpaceX company information

### API Rate Limiting
The SpaceX API has rate limiting in place. This application implements caching mechanisms to minimize API calls and ensure smooth operation within rate limits.

## Database Schema

### Users Collection
users/{userId}

uid: string
email: string
displayName: string
createdAt: timestamp
favoriteRockets: array
favoriteLaunches: array
notificationSettings: map
lastActive: timestamp

### Favorites Subcollection
users/{userId}/favorites/{favoriteId}

type: string (launch, rocket, ship, capsule)
itemId: string
itemName: string
addedAt: timestamp
imageUrl: string


### Notification Preferences
users/{userId}/notifications/{notificationId}

launchId: string
launchName: string
scheduledTime: timestamp
notifyBefore: string (1h, 24h, 1w)
isActive: boolean


## Configuration

### Android Setup

Add required permissions in android/app/src/main/AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### iOS Setup

Add required permissions in ios/Runner/Info.plist:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

Run unit tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter test integration_test
```

## Application Screens

1. Authentication
   - Login Screen
   - Registration Screen
   - Password Reset Screen

2. Main Navigation
   - Home Dashboard
   - Launches List (Upcoming/Past/All)
   - Launch Details
   - Vehicles (Rockets/Ships/Capsules)
   - Vehicle Details
   - Favorites
   - User Profile
   - Settings

## State Management

The application uses the Provider package for state management, implementing the following providers:

- AuthProvider: Manages user authentication state
- LaunchProvider: Handles launch data and filtering
- VehicleProvider: Manages vehicle data across different types
- FavoritesProvider: Synchronizes user favorites with Firebase

## Performance Optimization

- Image caching using cached_network_image
- Lazy loading for list views
- Pagination for large datasets
- Optimized Firebase queries with proper indexing
- Debouncing for search functionality
- Shimmer loading effects for better UX

## Contributing

Contributions are welcome. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (git checkout -b feature/YourFeature)
3. Commit your changes (git commit -m 'Add YourFeature')
4. Push to the branch (git push origin feature/YourFeature)
5. Open a Pull Request

### Code Style
- Follow Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting using dart format

## Known Issues and Limitations

- API rate limiting may affect real-time data updates during high usage
- Ship location tracking depends on data availability from SpaceX API
- Notification delivery may vary based on device power management settings

## Future Enhancements

- Social features for sharing favorite launches
- Augmented reality for vehicle visualization
- Historical mission statistics and analytics
- Multilingual support
- Offline mode with local data caching
- Integration with SpaceX livestreams
- Mission trajectory visualization

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

- SpaceX API for providing comprehensive launch and vehicle data
- Flutter team for the excellent framework
- Firebase for backend infrastructure
- The open-source community for various packages used in this project

## Contact and Support

For questions, issues, or suggestions:
- Open an issue on GitHub
- Email: your.email@example.com
- Project Repository: https://github.com/yourusername/spacex_go

## Version History

### Version 1.0.0 (Current)
- Initial release
- Core launch tracking functionality
- Vehicle information display
- User authentication and favorites
- Push notification support
- Dark mode support

## Documentation

For detailed documentation on specific components:
- API Integration: See docs/api_integration.md
- Firebase Setup: See docs/firebase_setup.md
- Contributing Guide: See CONTRIBUTING.md

## References

- SpaceX API Documentation: https://github.com/r-spacex/SpaceX-API
- Flutter Documentation: https://docs.flutter.dev
- Firebase Documentation: https://firebase.google.com/docs
