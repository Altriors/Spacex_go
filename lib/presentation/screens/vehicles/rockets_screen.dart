import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../data/models/rocket_model.dart';
import 'rocket_detail_screen.dart';

class RocketsScreen extends StatefulWidget {
  const RocketsScreen({super.key});

  @override
  State<RocketsScreen> createState() => _RocketsScreenState();
}

class _RocketsScreenState extends State<RocketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Fixed: Call fetchRockets() from VehicleProvider
      Provider.of<VehicleProvider>(context, listen: false).fetchRockets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rockets'),
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading rockets',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // ✅ Fixed: Call fetchRockets() from VehicleProvider
                      Provider.of<VehicleProvider>(context, listen: false).fetchRockets();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.rockets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rocket_launch,
                    size: 64,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rockets available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchRockets(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.rockets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return RocketCard(rocket: provider.rockets[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class RocketCard extends StatelessWidget {
  final RocketModel rocket;

  const RocketCard({super.key, required this.rocket});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RocketDetailScreen(rocket: rocket),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (rocket.flickrImages != null && rocket.flickrImages!.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: rocket.flickrImages!.first,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.rocket_launch, size: 64),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Center(
                  child: Icon(Icons.rocket_launch, size: 64),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rocket.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  if (rocket.company != null)
                    Text(
                      rocket.company!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (rocket.active != null)
                        Chip(
                          label: Text(
                            rocket.active! ? 'Active' : 'Retired',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: rocket.active!
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                        ),
                      if (rocket.height?.meters != null)
                        _buildInfoChip(
                          context,
                          'Height: ${rocket.height!.meters!.toStringAsFixed(1)}m',
                        ),
                      if (rocket.mass?.kg != null)
                        _buildInfoChip(
                          context,
                          'Mass: ${(rocket.mass!.kg! / 1000).toStringAsFixed(1)}t',
                        ),
                      if (rocket.successRatePct != null)
                        _buildInfoChip(
                          context,
                          'Success: ${rocket.successRatePct!.toStringAsFixed(0)}%',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}