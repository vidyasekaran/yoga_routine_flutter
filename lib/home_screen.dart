import 'package:flutter/material.dart';

import 'models.dart';
import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
/* This is my home screen state */

class _HomeScreenState extends State<HomeScreen> {
  BodyPart? _selectedBodyPart;
  int _globalTimerSeconds = 30; // Global timer for all poses
  int _transitionTimerSeconds = 1000; // Transition timer in milliseconds

  @override
  void initState() {
    super.initState();
    // Select first body part by default with global timer applied
    final firstBodyPart = bodyParts.first;
    _selectedBodyPart = BodyPart(
      id: firstBodyPart.id,
      name: firstBodyPart.name,
      description: firstBodyPart.description,
      poses: firstBodyPart.poses.map((pose) {
        return pose.copyWith(durationSeconds: _globalTimerSeconds);
      }).toList(),
    );
  }

  /*
  void _updateGlobalTimer(int delta) {
    setState(() {
      _globalTimerSeconds = (_globalTimerSeconds + delta).clamp(10, 300);
      // Update all poses in the selected body part
      if (_selectedBodyPart != null) {
        _selectedBodyPart = BodyPart(
          id: _selectedBodyPart!.id,
          name: _selectedBodyPart!.name,
          description: _selectedBodyPart!.description,
          poses: _selectedBodyPart!.poses.map((pose) {
            return pose.copyWith(durationSeconds: _globalTimerSeconds);
          }).toList(),
        );
      }
    });
  }

  void _updatePoseTimer(int poseIndex, int delta) {
    if (_selectedBodyPart == null) return;

    setState(() {
      final updatedPoses = List<YogaPose>.from(_selectedBodyPart!.poses);
      final currentPose = updatedPoses[poseIndex];
      final newDuration = (currentPose.durationSeconds + delta).clamp(5, 600);
      updatedPoses[poseIndex] = currentPose.copyWith(
        durationSeconds: newDuration,
      );

      _selectedBodyPart = BodyPart(
        id: _selectedBodyPart!.id,
        name: _selectedBodyPart!.name,
        description: _selectedBodyPart!.description,
        poses: updatedPoses,
      );
    });
  }

  void _updateTransitionTimer(int delta) {
    setState(() {
      _transitionTimerSeconds = (_transitionTimerSeconds + delta).clamp(
        500,
        5000,
      );
    });
  }

  void _removePose(int index) {
    if (_selectedBodyPart == null) return;
    setState(() {
      final updatedPoses = List<YogaPose>.from(_selectedBodyPart!.poses);
      if (index < 0 || index >= updatedPoses.length) return;
      updatedPoses.removeAt(index);
      _selectedBodyPart = BodyPart(
        id: _selectedBodyPart!.id,
        name: _selectedBodyPart!.name,
        description: _selectedBodyPart!.description,
        poses: updatedPoses,
      );
    });
  }

  void _startRoutine() {
    if (_selectedBodyPart == null) return;

    // Use the current poses with their individual durations
    final posesWithUpdatedDuration = _selectedBodyPart!.poses.map((pose) {
      return pose.copyWith(durationSeconds: pose.durationSeconds);
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutScreen(
          bodyPart: _selectedBodyPart!,
          poses: posesWithUpdatedDuration,
          transitionDurationMs: _transitionTimerSeconds,
        ),
      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yoga — Select body part')),
      body: ListView.builder(
        itemCount: bodyParts.length,
        itemBuilder: (context, index) {
          final bodyPart = bodyParts[index];

          return ListTile(
            title: Text(
              bodyPart.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text('${bodyPart.poses.length} poses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BodyPartDetailScreen(
                    bodyPart: BodyPart(
                      id: bodyPart.id,
                      name: bodyPart.name,
                      description: bodyPart.description,
                      poses: bodyPart.poses.map((pose) {
                        return pose.copyWith(
                          durationSeconds: _globalTimerSeconds,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BodyPartDetailScreen extends StatefulWidget {
  final BodyPart bodyPart;

  const BodyPartDetailScreen({super.key, required this.bodyPart});

  @override
  State<BodyPartDetailScreen> createState() => _BodyPartDetailScreenState();
}

class _BodyPartDetailScreenState extends State<BodyPartDetailScreen> {
  late BodyPart _bodyPart;
  int _globalTimerSeconds = 30;
  int _transitionTimerMs = 1000;

  @override
  void initState() {
    super.initState();
    _bodyPart = widget.bodyPart;
  }

  void _updateGlobalTimer(int delta) {
    setState(() {
      _globalTimerSeconds = (_globalTimerSeconds + delta)
          .clamp(10, 300)
          .toInt();

      _bodyPart = _bodyPart.copyWith(
        poses: _bodyPart.poses
            .map((p) => p.copyWith(durationSeconds: _globalTimerSeconds))
            .toList(),
      );
    });
  }

  void _updatePoseTimer(int index, int delta) {
    setState(() {
      final poses = List<YogaPose>.from(_bodyPart.poses);
      final pose = poses[index];

      poses[index] = pose.copyWith(
        durationSeconds: (pose.durationSeconds + delta).clamp(5, 600).toInt(),
      );

      _bodyPart = _bodyPart.copyWith(poses: poses);
    });
  }

  void _removePose(int index) {
    setState(() {
      final poses = List<YogaPose>.from(_bodyPart.poses);
      poses.removeAt(index);
      _bodyPart = _bodyPart.copyWith(poses: poses);
    });
  }

  void _updateTransitionTimer(int delta) {
    setState(() {
      _transitionTimerMs = (_transitionTimerMs + delta)
          .clamp(500, 5000)
          .toInt();
    });
  }

  void _startRoutine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutScreen(
          bodyPart: _bodyPart,
          poses: _bodyPart.poses,
          transitionDurationMs: _transitionTimerMs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_bodyPart.name)),
      body: Column(
        children: [
          // Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _bodyPart.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Global + Transition timers
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _timerRow(
                    label: 'All poses',
                    value: '${_globalTimerSeconds}s',
                    onMinus: () => _updateGlobalTimer(-5),
                    onPlus: () => _updateGlobalTimer(5),
                  ),
                  const SizedBox(height: 8),
                  _timerRow(
                    label: 'Transition',
                    value: '${(_transitionTimerMs / 1000).toStringAsFixed(1)}s',
                    onMinus: () => _updateTransitionTimer(-100),
                    onPlus: () => _updateTransitionTimer(100),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Pose list
          Expanded(
            child: ListView.builder(
              itemCount: _bodyPart.poses.length,
              itemBuilder: (context, index) {
                final pose = _bodyPart.poses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pose.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${pose.durationSeconds}s',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _updatePoseTimer(index, -5),
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: () => _updatePoseTimer(index, 5),
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () => _removePose(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Start button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _startRoutine,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Routine'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerRow({
    required String label,
    required String value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(onPressed: onMinus, icon: const Icon(Icons.remove)),
            Text(value),
            IconButton(onPressed: onPlus, icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}
