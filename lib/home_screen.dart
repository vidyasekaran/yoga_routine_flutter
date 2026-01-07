import 'package:flutter/material.dart';

import 'models.dart';
import 'workout_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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
      updatedPoses[poseIndex] = currentPose.copyWith(durationSeconds: newDuration);
      
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
      _transitionTimerSeconds =
          (_transitionTimerSeconds + delta).clamp(500, 5000);
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


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Yoga — Select body part'),
    ),
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

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar - Body parts
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yoga — Select body part',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pick a body area to see sequences.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: bodyParts.length,
                    itemBuilder: (context, index) {
                      final bodyPart = bodyParts[index];
                      final isSelected = _selectedBodyPart?.id == bodyPart.id;
                      
                      return InkWell(
                        onTap: () {
                          setState(() {
                            // Update poses with current global timer when selecting
                            _selectedBodyPart = BodyPart(
                              id: bodyPart.id,
                              name: bodyPart.name,
                              description: bodyPart.description,
                              poses: bodyPart.poses.map((pose) {
                                return pose.copyWith(
                                  durationSeconds: _globalTimerSeconds,
                                );
                              }).toList(),
                            );
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[50] : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          bodyPart.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Selected',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${bodyPart.poses.length} poses',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right side - Selected body part details
          Expanded(
            child: _selectedBodyPart == null
                ? const Center(child: Text('Select a body part'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and Start Routine button
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedBodyPart!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedBodyPart!.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _startRoutine,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Routine'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Global timer control
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Set timer for all poses:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  onPressed: () => _updateGlobalTimer(-5),
                                  icon: const Icon(Icons.remove),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${_globalTimerSeconds}s',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _updateGlobalTimer(5),
                                  icon: const Icon(Icons.add),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Transition timer control
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Transition:',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => _updateTransitionTimer(-100),
                                  icon: const Icon(Icons.remove, size: 18),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    padding: const EdgeInsets.all(6),
                                    minimumSize: const Size(32, 32),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 60,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(_transitionTimerSeconds / 1000).toStringAsFixed(1)}s',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _updateTransitionTimer(100),
                                  icon: const Icon(Icons.add, size: 18),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    padding: const EdgeInsets.all(6),
                                    minimumSize: const Size(32, 32),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Poses list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _selectedBodyPart!.poses.length,
                          itemBuilder: (context, index) {
                            final pose = _selectedBodyPart!.poses[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Pose image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: pose.imageAsset != null
                                          ? Image.asset(
                                              pose.imageAsset!,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 70,
                                                  height: 70,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.self_improvement,
                                                    size: 35,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 70,
                                              height: 70,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.self_improvement,
                                                size: 35,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Pose info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            pose.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Hold for ${pose.durationSeconds} sec',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Individual timer controls + remove
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _updatePoseTimer(index, -5),
                                          icon: const Icon(Icons.remove, size: 18),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            padding: const EdgeInsets.all(6),
                                            minimumSize: const Size(32, 32),
                                            tapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 50,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${pose.durationSeconds}s',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _updatePoseTimer(index, 5),
                                          icon: const Icon(Icons.add, size: 18),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            padding: const EdgeInsets.all(6),
                                            minimumSize: const Size(32, 32),
                                            tapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          onPressed: () => _removePose(index),
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 18,
                                          ),
                                          tooltip: 'Remove pose',
                                          style: IconButton.styleFrom(
                                            foregroundColor: Colors.redAccent,
                                            padding: const EdgeInsets.all(6),
                                            minimumSize: const Size(32, 32),
                                            tapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Tip at bottom
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Tip: adjust per-pose timing, then press Start to run the routine.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }*/
}

class BodyPartDetailScreen extends StatefulWidget {
  final BodyPart bodyPart;

  const BodyPartDetailScreen({
    super.key,
    required this.bodyPart,
  });

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
      _globalTimerSeconds =
          (_globalTimerSeconds + delta).clamp(10, 300).toInt();

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
        durationSeconds:
            (pose.durationSeconds + delta).clamp(5, 600).toInt(),
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
      _transitionTimerMs =
          (_transitionTimerMs + delta).clamp(500, 5000).toInt();
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
      appBar: AppBar(
        title: Text(_bodyPart.name),
      ),
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
                    value:
                        '${(_transitionTimerMs / 1000).toStringAsFixed(1)}s',
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                              Text(
                                '${pose.durationSeconds}s',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              _updatePoseTimer(index, -5),
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: () =>
                              _updatePoseTimer(index, 5),
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
