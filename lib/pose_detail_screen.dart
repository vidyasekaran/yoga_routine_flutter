import 'package:flutter/material.dart';

import 'models.dart';

/* Pose detail screen */
class PoseDetailScreen extends StatelessWidget {
  final YogaPose pose;

  const PoseDetailScreen({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pose.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (pose.imageAsset != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  pose.imageAsset!,
                  fit: BoxFit.cover,
                  height: 220,
                ),
              )
            else
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: const Icon(Icons.self_improvement, size: 80),
              ),
            const SizedBox(height: 24),
            Text('Duration', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('${pose.durationSeconds} seconds'),
            const SizedBox(height: 24),
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              pose.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
