import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<AuthProviderApp>(
        builder: (context, authProvider, child) {
          final user = authProvider.userModel;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          user?.displayName?.substring(0, 1).toUpperCase() ??
                              user?.email.substring(0, 1).toUpperCase() ??
                              'U',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (user?.displayName != null)
                        Text(
                          user!.displayName!,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      Text(
                        user?.email ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('Favorite Launches'),
                      trailing: Text(
                        '${user?.favoriteLaunches.length ?? 0}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return SwitchListTile(
                          secondary: const Icon(Icons.dark_mode),
                          title: const Text('Dark Mode'),
                          value: themeProvider.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            themeProvider.setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'SpaceX GO',
                          applicationVersion: '1.0.0',
                          applicationIcon: const Icon(
                            Icons.rocket_launch,
                            size: 48,
                          ),
                          children: [
                            const Text(
                              'Track SpaceX launches and explore vehicles.',
                            ),
                          ],
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                                'Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          await authProvider.signOut();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}