class YogaPose {
  final String id;
  final String name;
  final String description;
  final String? imageAsset;
  int durationSeconds; // Made mutable for global timer adjustment

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
  id: 'childs_pose',
  name: 'Child\'s Pose',
  description: 'Sit back on your heels, fold forward, and rest your forehead on the mat.',
  imageAsset: 'images/lowerback/child-pose.jpg',
  durationSeconds: 30,
),

 YogaPose(
  id: 'cat_cow',
  name: 'Cat-Cow',
  description: 'Move between arching your back (cow) and rounding it (cat) on hands and knees.',
  imageAsset: 'images/lowerback/cat-cow.jpg',
  durationSeconds: 40,
),

 YogaPose(
  id: 'knees_to_chest',
  name: 'Knees-to-Chest',
  description: 'Lie on your back and pull your knees toward your chest.',
  imageAsset: 'images/lowerback/knees-chest.jpg',
  durationSeconds: 30,
),

 YogaPose(
  id: 'cobra_pose',
  name: 'cobra_pose',
  description: '....',
  imageAsset: 'images/lowerback/Bhujangasana-cobra.jpg',
  durationSeconds: 30,
),

 YogaPose(
  id: 'Setu-bandhasana',
  name: 'Setu-bandhasana',
  description: 'Lie on your back and pull your knees toward your chest.',
  imageAsset: 'images/lowerback/Setu-bandhasana.jpg',
  durationSeconds: 30,
),

 YogaPose(
  id: 'Ardha_Matsyendrasana',
  name: 'Ardha_Matsyendrasana',
  description: 'Lie on your back and pull your knees toward your chest.',
  imageAsset: 'images/lowerback/Ardha_Matsyendrasana.jpg',
  durationSeconds: 30,
),

 YogaPose(
  id: 'salabhasana-pose',
  name: 'salabhasana-pose',
  description: 'Lie on your back and pull your knees toward your chest.',
  imageAsset: 'images/lowerback/salabhasana-pose.jpg',
  durationSeconds: 30,
),

 YogaPose(
  id: 'viparita-karani',
  name: 'viparita-karani',
  description: 'Lie on your back and pull your knees toward your chest.',
  imageAsset: 'images/lowerback/Viparita-karani.jpg',
  durationSeconds: 30,
),
YogaPose(
  id: 'downward-facing-dog',
  name: 'downward-facing-dog',
  description: 'Lie on your back and pull your knees toward your chest.',
  imageAsset: 'images/lowerback/downward-facing-dog.jpg',
  durationSeconds: 30,
),
];

final shoulderPoses = [
  YogaPose(
    id: 'shoulder_roll',
    name: 'Shoulder Roll',
    description: 'Roll your shoulders forward and backward in circular motions.',
    imageAsset: 'images/shoulder-rolls.jpg',
    durationSeconds: 30,
  ),
  YogaPose(
    id: 'thread_needle',
    name: 'Thread the Needle',
    description: 'Thread one arm under the body while on hands and knees, then switch sides.',
    imageAsset: 'images/thread-needle.jpg',
    durationSeconds: 40,
  ),
  YogaPose(
    id: 'eagle_arms',
    name: 'Eagle Arms',
    description: 'Wrap one arm under the other and hold, then switch sides.',
    imageAsset: 'images/eagle-arms.jpg',
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
];

final bodyParts = [
  BodyPart(
    id: 'lower_back',
    name: 'Lower Back',
    description: 'Stretches and gentle twists for lower back relief.',
    poses: 
      childsPose,   
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
