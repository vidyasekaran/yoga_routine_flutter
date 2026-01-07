import 'package:flutter/material.dart';

import 'models.dart';
import 'pose_detail_screen.dart';
import 'workout_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final YogaRoutine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              routine.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: routine.poses.length,
              itemBuilder: (context, index) {
                final pose = routine.poses[index];
                return ListTile(
                  leading: pose.imageAsset != null
                      ? CircleAvatar(
                          backgroundImage: AssetImage(pose.imageAsset!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.self_improvement),
                        ),
                  title: Text(pose.name),
                  subtitle: Text('${pose.durationSeconds} seconds'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PoseDetailScreen(pose: pose),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Routine'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WorkoutScreen(routine: routine),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


