import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/auth/animated_login_screen.dart';
import 'presentation/screens/home/home_screen.dart';

class SpaceXApp extends StatelessWidget {
  const SpaceXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'SpaceX GO',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: Consumer<AuthProviderApp>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoading) {
                return const SplashScreen();
              }
              return authProvider.user != null
                  ? const HomeScreen()
                  : const AnimatedLoginScreen();
            },
          ),
        );
      },
    );
  }
}