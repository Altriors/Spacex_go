import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/launch_model.dart';
import '../../../providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LaunchDetailScreen extends StatelessWidget {
  final LaunchModel launch;

  const LaunchDetailScreen({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(launch.name),
        actions: [
          Consumer<AuthProviderApp>(
            builder: (context, authProvider, child) {
              final isFav = authProvider.isFavorite(launch.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  if (isFav) {
                    authProvider.removeFavorite(launch.id);
                  } else {
                    authProvider.addFavorite(launch.id);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (launch.links?.patch?.large != null)
              CachedNetworkImage(
                imageUrl: launch.links!.patch!.large!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    launch.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    context,
                    Icons.calendar_today,
                    'Date',
                    launch.dateUtc != null
                        ? DateFormat('MMM dd, yyyy HH:mm').format(launch.dateUtc!)
                        : 'TBD',
                  ),
                  // Agency info
                  if (launch.agency != null)
                    _buildInfoRow(
                      context,
                      Icons.business,
                      'Agency',
                      '${launch.agency!.name}${launch.agency!.countryCode != null ? " (${launch.agency!.countryCode})" : ""}',
                    ),
                  _buildInfoRow(
                    context,
                    Icons.numbers,
                    'Flight Number',
                    launch.flightNumber ?? 'N/A',
                  ),
                  _buildInfoRow(
                    context,
                    Icons.check_circle,
                    'Status',
                    launch.status ??
                        (launch.success == true
                            ? 'Success'
                            : launch.success == false
                                ? 'Failed'
                                : launch.upcoming == true
                                    ? 'Upcoming'
                                    : 'Unknown'),
                  ),
                  const SizedBox(height: 24),
                  if (launch.details != null) ...[
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      launch.details!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (launch.links != null && 
                      (launch.links!.webcast != null || 
                       launch.links!.article != null || 
                       launch.links!.wikipedia != null)) ...[
                    Text(
                      'Links',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (launch.links!.webcast != null)
                      _buildLinkButton(
                        context,
                        'Watch Webcast',
                        Icons.play_circle_outline,
                        launch.links!.webcast!,
                      ),
                    if (launch.links!.article != null)
                      _buildLinkButton(
                        context,
                        'Read Article',
                        Icons.article_outlined,
                        launch.links!.article!,
                      ),
                    if (launch.links!.wikipedia != null)
                      _buildLinkButton(
                        context,
                        'Wikipedia',
                        Icons.menu_book,
                        launch.links!.wikipedia!,
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

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
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

  Widget _buildLinkButton(
      BuildContext context, String label, IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}