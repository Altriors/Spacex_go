import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/launch_model.dart';

class LaunchCard extends StatelessWidget {
  final LaunchModel launch;
  final VoidCallback onTap;

  const LaunchCard({
    super.key,
    required this.launch,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (launch.links?.patch?.small != null)
                CachedNetworkImage(
                  imageUrl: launch.links!.patch!.small!,
                  width: 60,
                  height: 60,
                  placeholder: (context, url) => const SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.rocket_launch,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.rocket_launch,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launch.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Agency name
                    if (launch.agency != null)
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 14,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              launch.agency!.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    if (launch.dateUtc != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(launch.dateUtc!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    if (launch.flightNumber != null)
                      Text(
                        'Flight #${launch.flightNumber}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Icon(
                launch.success == true
                    ? Icons.check_circle
                    : launch.success == false
                        ? Icons.cancel
                        : launch.upcoming == true
                            ? Icons.schedule
                            : Icons.help_outline,
                color: launch.success == true
                    ? Colors.green
                    : launch.success == false
                        ? Colors.red
                        : Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}