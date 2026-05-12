import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test_app/data/models/rocket_model.dart';

class RocketDetailScreen extends StatelessWidget {
  final RocketModel rocket;

  const RocketDetailScreen({super.key, required this.rocket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rocket.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (rocket.flickrImages != null && rocket.flickrImages!.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: rocket.flickrImages!.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: rocket.flickrImages![index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.rocket_launch, size: 64),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 300,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Center(
                  child: Icon(Icons.rocket_launch, size: 100),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rocket.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (rocket.company != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      rocket.company!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _buildSpecsSection(context),
                  const SizedBox(height: 24),
                  if (rocket.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rocket.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildSpecRow(
          context,
          'Status',
          rocket.active == true ? 'Active' : rocket.active == false ? 'Retired' : 'Unknown',
        ),
        if (rocket.country != null)
          _buildSpecRow(context, 'Country', rocket.country!),
        if (rocket.firstFlight != null)
          _buildSpecRow(context, 'First Flight', rocket.firstFlight!),
        if (rocket.stages != null)
          _buildSpecRow(context, 'Stages', rocket.stages.toString()),
        if (rocket.height?.meters != null)
          _buildSpecRow(
            context,
            'Height',
            '${rocket.height!.meters!.toStringAsFixed(1)} m (${rocket.height!.feet?.toStringAsFixed(1) ?? "N/A"} ft)',
          ),
        if (rocket.diameter?.meters != null)
          _buildSpecRow(
            context,
            'Diameter',
            '${rocket.diameter!.meters!.toStringAsFixed(1)} m (${rocket.diameter!.feet?.toStringAsFixed(1) ?? "N/A"} ft)',
          ),
        if (rocket.mass?.kg != null)
          _buildSpecRow(
            context,
            'Mass',
            '${(rocket.mass!.kg! / 1000).toStringAsFixed(1)} tonnes (${rocket.mass!.lb != null ? (rocket.mass!.lb! / 2204.62).toStringAsFixed(1) : "N/A"} tons)',
          ),
        if (rocket.costPerLaunch != null)
          _buildSpecRow(
            context,
            'Cost per Launch',
            '\$${(rocket.costPerLaunch! / 1000000).toStringAsFixed(1)}M',
          ),
        if (rocket.successRatePct != null)
          _buildSpecRow(
            context,
            'Success Rate',
            '${rocket.successRatePct!.toStringAsFixed(1)}%',
          ),
      ],
    );
  }

  Widget _buildSpecRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}