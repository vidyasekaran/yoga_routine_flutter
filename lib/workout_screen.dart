import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import 'models.dart';

class WorkoutScreen extends StatefulWidget {
  final BodyPart bodyPart;
  final List<YogaPose> poses;
  final int transitionDurationMs;

  const WorkoutScreen({
    super.key,
    required this.bodyPart,
    required this.poses,
    this.transitionDurationMs = 1000,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Timer? _timer;
  Timer? _transitionTimer;
  int _currentPoseIndex = 0;
  int _secondsRemaining = 0;
  bool _isPaused = false;
  bool _isTransitioning = false;
  int _transitionSecondsRemaining = 0; // ← add this
  VideoPlayerController? _videoController;
  bool _isVideoLoading = true;

  Future<void> _loadVideo(YogaPose pose) async {
    if (pose.videoAsset == null) return;

    setState(() {
      _isVideoLoading = true;
    });

    _videoController?.dispose();

    _videoController = VideoPlayerController.asset(pose.videoAsset!);
    await _videoController!.initialize();

    _videoController!
      ..setLooping(true)
      ..play();

    setState(() {
      _isVideoLoading = false;
    });
  }

  YogaPose? get _currentPose {
    if (_currentPoseIndex >= 0 && _currentPoseIndex < widget.poses.length) {
      return widget.poses[_currentPoseIndex];
    }
    return null;
  }

  YogaPose? get _nextPose => _currentPoseIndex < widget.poses.length - 1
      ? widget.poses[_currentPoseIndex + 1]
      : null;

  @override
  void initState() {
    super.initState();
    _startPose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPose() {
    // Cancel any existing timer first
    _timer?.cancel();
    _timer = null;

    // Safety check: ensure we have a valid pose
    if (_currentPoseIndex < 0 || _currentPoseIndex >= widget.poses.length) {
      return;
    }

    if (_currentPose == null) return;

    _loadVideo(_currentPose!);
    // Reset state for new pose
    setState(() {
      _secondsRemaining = _currentPose!.durationSeconds;
      _isPaused = false;
    });

    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (!_isPaused && !_isTransitioning) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          }

          if (_secondsRemaining <= 0) {
            timer.cancel(); // Cancel timer before advancing
            _advanceToNextPose();
          }
        });
      }
    });
  }

  Future<void> _advanceToNextPose() async {
    // Cancel any existing timers
    _timer?.cancel();
    _timer = null;
    _transitionTimer?.cancel();
    _transitionTimer = null;

    if (_currentPoseIndex < widget.poses.length - 1) {
      // Show transition animation + start transition countdown
      if (mounted) {
        final totalTransitionSeconds = (widget.transitionDurationMs / 1000)
            .ceil();

        setState(() {
          _isTransitioning = true;
          _transitionSecondsRemaining = totalTransitionSeconds;
        });

        _transitionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (!mounted) {
            t.cancel();
            return;
          }
          setState(() {
            _transitionSecondsRemaining--;
            if (_transitionSecondsRemaining <= 0) {
              t.cancel();
            }
          });
        });
      }

      // Wait for full transition duration
      await Future.delayed(Duration(milliseconds: widget.transitionDurationMs));

      if (mounted) {
        setState(() {
          _currentPoseIndex++;
          _isTransitioning = false;
        });
        _startPose();
      }
    } else {
      _timer?.cancel();
      _transitionTimer?.cancel();
      _timer = null;
      _transitionTimer = null;
      if (mounted) {
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Routine Complete'),
        content: const Text('Great job! You have finished this routine.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop() // Close dialog
                ..pop(); // Go back to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _restart() {
    setState(() {
      _currentPoseIndex = 0;
      _isTransitioning = false;
    });
    _startPose();
  }

  void _exit() {
    _timer?.cancel();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final pose = _currentPose;
    if (pose == null) {
      return Scaffold(body: Center(child: Text('Error: No pose available')));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isVideoLoading) ...[
                    // Pose name and instruction
                    Text(
                      pose.name,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Hold this pose.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Timer display
                    Text(
                      '${_secondsRemaining}s',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 72,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Video or image
                          if (_videoController != null &&
                              _videoController!.value.isInitialized)
                            AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          else if (pose.imageAsset != null)
                            Image.asset(pose.imageAsset!, fit: BoxFit.contain),

                          // Loading indicator
                          if (_isVideoLoading)
                            const Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: LinearProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),

                  if (_nextPose != null)
                    Text(
                      'Next: ${_nextPose?.name} — ${_nextPose?.durationSeconds}s',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(
                      'Last pose',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 48),
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _togglePause,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(_isPaused ? 'Resume' : 'Pause'),
                        ),
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _restart,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Restart'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _exit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Exit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Transition overlay
            if (_isTransitioning)
              AnimatedOpacity(
                opacity: _isTransitioning ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/pose-transition.svg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${_transitionSecondsRemaining}s',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
