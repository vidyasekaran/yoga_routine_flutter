class YogaPose {
  final String id;
  final String name;
  final String description;
  final String? imageAsset;
  int durationSeconds; // Made mutable for global timer adjustment

  /* These are yogapose model */

  YogaPose({
    required this.id,
    required this.name,
    required this.description,
    this.imageAsset,
    required this.durationSeconds,
  });

  YogaPose copyWith({int? durationSeconds}) {
    return YogaPose(
      id: id,
      name: name,
      description: description,
      imageAsset: imageAsset,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }
}

class BodyPart {
  final String id;
  final String name;
  final String description;
  final List<YogaPose> poses;

  const BodyPart({
    required this.id,
    required this.name,
    required this.description,
    required this.poses,
  });

  BodyPart copyWith({
    String? id,
    String? name,
    String? description,
    List<YogaPose>? poses,
  }) {
    return BodyPart(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      poses: poses ?? this.poses,
    );
  }
}

// Sample poses matching the UI with correct image paths
final childsPose = [
  YogaPose(
    id: 'cobra_pose',
    name: 'cobra_pose',
    description: '....',
    imageAsset: 'assets/images/Bhujangasana-cobra.jpg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'Ardha_Matsyendrasana',
    name: 'Ardha_Matsyendrasana',
    description: 'Lie on your back and pull your knees toward your chest.',
    imageAsset: 'assets/images/Ardha_Matsyendrasana.jpg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'viparita-karani',
    name: 'viparita-karani',
    description: 'Lie on your back and pull your knees toward your chest.',
    imageAsset: 'assets/images/viparita.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'downward-facing-dog',
    name: 'downward-facing-dog',
    description: 'Lie on your back and pull your knees toward your chest.',
    imageAsset: 'assets/images/downward-facing-dog.jpg',
    durationSeconds: 30,
  ),
];

final shoulderPoses = [
  YogaPose(
    id: 'shoulder_roll',
    name: 'Shoulder Roll',
    description:
        'Roll your shoulders forward and backward in circular motions.',
    imageAsset: 'assets/images/shoulder-rolls.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'thread_needle',
    name: 'Thread the Needle',
    description:
        'Thread one arm under the body while on hands and knees, then switch sides.',
    imageAsset: 'assets/images/thread-needle.jpg',
    durationSeconds: 40,
  ),
  YogaPose(
    id: 'eagle_arms',
    name: 'Eagle Arms',
    description: 'Wrap one arm under the other and hold, then switch sides.',
    imageAsset: 'assets/images/eagle-arms.jpg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'shoulder_updown',
    name: 'Shoulder updown',
    description: 'Thread the needle pose.',
    imageAsset: 'assets/images/shoulder-updown.jpg',
    durationSeconds: 30,
  ),
];

final puppyPose = [
  YogaPose(
    id: 'puppy_pose',
    name: 'Puppy Pose',
    description: 'Slowly turn your head to one side, hold, then switch.',
    imageAsset: 'assets/images/puppy-pose.png',
    durationSeconds: 30,
  ),
];

final lowerBack = [
  YogaPose(
    id: 'childs_pose',
    name: 'Child\'s Pose',
    description:
        'Gently stretches the spine and relaxes the lower back and hips.',
    imageAsset: 'assets/images/child-pose.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'cat_cow',
    name: 'Cat-Cow',
    description:
        'Improves spinal mobility and relieves stiffness in the lower back.',
    imageAsset: 'assets/images/cat-cow.jpg',
    durationSeconds: 40,
  ),
  YogaPose(
    id: 'parsva_balasana',
    name: 'Parsva Balasana',
    description:
        'Releases tension in the spine, shoulders, and lower back through a gentle twist.',
    imageAsset: 'assets/images/parsva_balasana.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'knees_to_chest',
    name: 'Knees-to-Chest',
    description:
        'Decompresses the lower spine and relieves lower back tightness.',
    imageAsset: 'assets/images/knees-chest.jpg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'happy-baby-pose',
    name: 'happy-baby-pose',
    description: 'Relaxes the lower back while opening the hips and pelvis.',
    imageAsset: 'assets/images/happy-baby-pose.webp',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'Setu-bandhasana',
    name: 'Setu-bandhasana',
    description:
        'Strengthens the lower back and glutes while improving spinal support.',
    imageAsset: 'assets/images/Setu-bandhasana.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'salabhasana-pose',
    name: 'salabhasana-pose',
    description:
        'Builds strength in the lower back muscles and improves posture.',
    imageAsset: 'assets/images/salabhasana-pose.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'spinal_twist',
    name: 'Spinal Twist',
    description:
        'Gently twists the spine to release tension and improve flexibility in the back.',
    imageAsset: 'assets/images/spinal-twist.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'supine_spinal_twist',
    name: 'SupineSpinal Twist',
    description:
        'Gently twists the spine to release lower back tension and improve flexibility.',
    imageAsset: 'assets/images/supine-spinal-twist.jpeg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'malasana-pose',
    name: 'malasana-pose',
    description:
        'Opens the hips and releases accumulated tension in the lower back.',
    imageAsset: 'assets/images/malasana-asana-yoga.jpg',
    durationSeconds: 30,
  ),
];

final neckPoses = [
  YogaPose(
    id: 'neck_turn',
    name: 'Neck Turn',
    description: 'Slowly turn your head to one side, hold, then switch.',
    imageAsset: 'assets/images/neck-turn.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'neck_tilt',
    name: 'Neck Tilt',
    description: 'Tilt your head to one side, hold, then switch.',
    imageAsset: 'assets/images/neck-tilt.jpg',
    durationSeconds: 40,
  ),
  YogaPose(
    id: 'chin_tuck',
    name: 'Chin Tuck',
    description: 'Gently tuck your chin toward your chest and hold.',
    imageAsset: 'assets/images/chin-tuck.jpg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'neck-roll',
    name: 'Neck Roll',
    description: 'Gently tuck your chin toward your chest and hold.',
    imageAsset: 'assets/images/neck-roll.jpg',
    durationSeconds: 30,
  ),

  YogaPose(
    id: 'neck-updown',
    name: 'Neck Up Down',
    description: 'Gently tuck your chin toward your chest and hold.',
    imageAsset: 'assets/images/neck-updown.jpg',
    durationSeconds: 30,
  ),
];

final bodyParts = [
  BodyPart(
    id: 'lower_back',
    name: 'Lower Back',
    description: 'Stretches and gentle twists for lower back relief.',
    poses: lowerBack,
  ),
  BodyPart(
    id: 'upper_back',
    name: 'Upper Back',
    description: 'Stretches and gentle twists for lower back relief.',
    poses: puppyPose,
  ),

  BodyPart(
    id: 'shoulder',
    name: 'Shoulder',
    description: 'Exercises to relieve shoulder tension and improve mobility.',
    poses: shoulderPoses,
  ),
  BodyPart(
    id: 'neck',
    name: 'Neck',
    description: 'Gentle stretches to release neck tension.',
    poses: neckPoses,
  ),
];
