import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/launch_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //  Initialize Hive
  await Hive.initFlutter();

  //  Open Hive boxes before use (match names used in ApiService)
  await Hive.openBox('launches_cache');
  await Hive.openBox('vehicles_cache');

  //  Run app after all setup
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviderApp()),
        ChangeNotifierProvider(create: (_) => LaunchProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const SpaceXApp(),
    );
  }
}
