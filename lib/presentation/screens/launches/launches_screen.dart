import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/launch_provider.dart';
import '../../widgets/launch_card.dart';
import 'launch_detail_screen.dart';

class LaunchesScreen extends StatefulWidget {
  const LaunchesScreen({super.key});

  @override
  State<LaunchesScreen> createState() => _LaunchesScreenState();
}

class _LaunchesScreenState extends State<LaunchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LaunchProvider>(context, listen: false);
      provider.fetchUpcomingLaunches();
      provider.fetchPastLaunches();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Launches'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingLaunches(),
          _buildPastLaunches(),
        ],
      ),
    );
  }

  Widget _buildUpcomingLaunches() {
    return Consumer<LaunchProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return _buildErrorState(
            context,
            provider.errorMessage!,
            onRetry: provider.fetchUpcomingLaunches,
          );
        }

        if (provider.upcomingLaunches.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.rocket_launch,
            message: 'No upcoming launches',
            onRefresh: provider.fetchUpcomingLaunches,
          );
        }

        return RefreshIndicator(
          onRefresh: provider.fetchUpcomingLaunches,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.upcomingLaunches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final launch = provider.upcomingLaunches[index];
              return LaunchCard(
                launch: launch,
                onTap: () {
                  // Navigate to launch detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LaunchDetailScreen(launch: launch),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPastLaunches() {
    return Consumer<LaunchProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null && provider.pastLaunches.isEmpty) {
          return _buildErrorState(
            context,
            provider.errorMessage!,
            onRetry: provider.fetchPastLaunches,
          );
        }

        if (provider.pastLaunches.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.history,
            message: 'No past launches',
            onRefresh: provider.fetchPastLaunches,
          );
        }

        return RefreshIndicator(
          onRefresh: provider.fetchPastLaunches,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.pastLaunches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final launch = provider.pastLaunches[index];
              return LaunchCard(
                launch: launch,
                onTap: () {
                  // Navigate to launch detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LaunchDetailScreen(launch: launch),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message,
      {required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error loading launches',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context,
      {required IconData icon,
      required String message,
      required Future<void> Function() onRefresh}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}