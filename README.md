# SpaceX GO

A Flutter application for tracking SpaceX launches, rockets, ships, and capsules with Firebase integration for authentication, cloud storage, and notifications.

---

## Overview

SpaceX GO provides real-time and historical SpaceX mission data through the SpaceX API. Users can explore launch details, vehicle specifications, mission history, and receive launch notifications through a modern mobile interface.

---

# Features

## Launch Tracking

* Browse upcoming and past launches
* View mission details, launch sites, payload information, and launch status
* Real-time countdown timers for upcoming launches
* Search and filter functionality
* Mission patches, webcast links, and related articles

## Vehicle Information

* Rocket specifications and performance details
* Dragon capsule information and flight history
* Ship tracking and operational data
* High-quality images and technical details

## Notifications

* Launch reminder notifications
* Configurable notification intervals
* Firebase Cloud Messaging integration

## User Features

* Email and password authentication
* Favorites system for launches and vehicles
* User profile management
* Firebase synchronization
* Dark and light theme support

---

# Technology Stack

## Frontend

* Flutter
* Provider (State Management)
* Material Design

## Backend

* Firebase Authentication
* Cloud Firestore
* Firebase Cloud Messaging
* SpaceX API v4

## Main Dependencies

* firebase_core
* firebase_auth
* cloud_firestore
* dio
* provider
* flutter_local_notifications
* cached_network_image
* intl

---

# Project Structure

```text
spacex_go/
├── lib/
│   ├── core/
│   ├── data/
│   ├── presentation/
│   ├── routes/
│   ├── app.dart
│   └── main.dart
├── assets/
├── android/
├── ios/
├── web/
├── test/
└── pubspec.yaml
```

---

# Getting Started

## Prerequisites

* Flutter SDK 3.0+
* Dart SDK 3.0+
* Android Studio or VS Code
* Firebase Project
* Git

## Installation

### Clone the Repository

```bash
git clone https://github.com/Altriors/Spacex_go.git
cd spacex_go
```

### Install Dependencies

```bash
flutter pub get
```

### Firebase Setup

1. Create a Firebase project
2. Add Android and/or iOS apps
3. Download:

   * `google-services.json` → `android/app/`
   * `GoogleService-Info.plist` → `ios/Runner/`
4. Enable:

   * Authentication
   * Cloud Firestore
   * Firebase Cloud Messaging

### Configure Firebase

```bash
flutterfire configure
```

### Run the Application

```bash
flutter run
```

---

# API Integration

This project uses the SpaceX API v4.

## Base URL

```text
https://api.spacexdata.com/v4/
```

## Main Endpoints

```text
/launches
/launches/upcoming
/launches/past
/rockets
/ships
/capsules
/company
```

---

# Android Permissions

Add the following permissions in:

```text
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

---

# Build Commands

## Android

```bash
flutter build apk --release
flutter build appbundle --release
```

## iOS

```bash
flutter build ios --release
```

---

# Testing

## Unit Tests

```bash
flutter test
```

## Integration Tests

```bash
flutter test integration_test
```

---

# Application Modules

* Authentication
* Launch Tracking
* Vehicle Information
* Favorites
* Notifications
* User Profile
* Settings

---

# State Management

The application uses the Provider package for state management.

## Providers

* AuthProvider
* LaunchProvider
* VehicleProvider
* FavoritesProvider

---

# Performance Optimizations

* Cached image loading
* Lazy loading
* Pagination
* Optimized Firebase queries
* Search debouncing

---

# Contributing

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/feature-name
```

3. Commit changes

```bash
git commit -m "Add feature"
```

4. Push changes

```bash
git push origin feature/feature-name
```

5. Open a Pull Request

---

# Known Limitations

* API rate limiting may affect frequent refresh requests
* Ship tracking depends on SpaceX API availability
* Notification delivery may vary depending on device settings

---

# Future Improvements

* Offline support
* Mission analytics
* Livestream integration
* Multilingual support
* AR-based vehicle visualization

---

# References

* SpaceX API: https://github.com/r-spacex/SpaceX-API
* Flutter Documentation: https://docs.flutter.dev
* Firebase Documentation: https://firebase.google.com/docs
