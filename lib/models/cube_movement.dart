import 'package:angles/angles.dart';
import 'package:very_good_slide_puzzle/models/cube.dart';
import 'package:very_good_slide_puzzle/models/cube_faces.dart';

///Defines changes that need to be made to the orientation of the cube when
///switching between certain sides of the cube
class MovementRule {
  ///Movement rule constructor
  const MovementRule({
    required this.startFace,
    required this.endFace,
    required this.orientationChange,
  });

  ///visible side before movement
  final Face startFace;

  ///visible side after movement
  final Face endFace;

  ///Orientation change of the cube in degrees
  final Angle orientationChange;
}

///List of all [MovementRule]'s that for a cube
const List<MovementRule> movementRules = [
  MovementRule(
    startFace: Face.F,
    endFace: Face.B,
    orientationChange: Angle.degrees(-90),
  ),
  MovementRule(
    startFace: Face.B,
    endFace: Face.E,
    orientationChange: Angle.degrees(-90),
  ),
  MovementRule(
    startFace: Face.E,
    endFace: Face.D,
    orientationChange: Angle.degrees(-90),
  ),
  MovementRule(
    startFace: Face.D,
    endFace: Face.F,
    orientationChange: Angle.degrees(-90),
  ),
  MovementRule(
    startFace: Face.C,
    endFace: Face.D,
    orientationChange: Angle.degrees(180),
  ),
  MovementRule(
    startFace: Face.C,
    endFace: Face.B,
    orientationChange: Angle.degrees(180),
  ),
];

///Calculate the resulting orientation change for the cube when moved between a
///given start and end side
Angle calculateCubeOrientationChange({
  required Face startFace,
  required Face endFace,
}) {
  final movementRuleIndex = movementRules.indexWhere(
      (MovementRule movementRule) =>
          ((startFace == movementRule.startFace) &&
              (endFace == movementRule.endFace)) ||
          ((startFace == movementRule.endFace) &&
              (endFace == movementRule.startFace)),);
  if (movementRuleIndex == -1) {
    return const Angle.degrees(0);
  }
  else if (movementRules[movementRuleIndex].startFace == startFace) {
    return movementRules[movementRuleIndex].orientationChange;
  } else if (movementRules[movementRuleIndex].startFace == endFace) {
    return movementRules[movementRuleIndex].orientationChange +
        const Angle.degrees(180);
  } else {
    return const Angle.degrees(0);
  }
}

///Defines the sides to the top,left,bottom and right of a face on the cube
class FaceRelationship {
  ///Side relationship constructor
  const FaceRelationship({
    required this.visibleFace,
    required this.faceToTop,
    required this.faceToRight,
    required this.faceToBottom,
    required this.faceToLeft,
  });

  ///visible side
  final Face visibleFace;

  ///Side to Top
  final Face faceToTop;

  ///Side to Right
  final Face faceToRight;

  ///Side to Bottom
  final Face faceToBottom;

  ///Side to Left
  final Face faceToLeft;
}

//List of Side relationships for all sides when  side is oriented at 0 degrees

const List<FaceRelationship> faceRelationships = [
  FaceRelationship(
    visibleFace: Face.A,
    faceToTop: Face.F,
    faceToRight: Face.B,
    faceToBottom: Face.E,
    faceToLeft: Face.D,
  ),
  FaceRelationship(
    visibleFace: Face.B,
    faceToTop: Face.F,
    faceToRight: Face.C,
    faceToBottom: Face.E,
    faceToLeft: Face.A,
  ),
  FaceRelationship(
    visibleFace: Face.C,
    faceToTop: Face.E,
    faceToRight: Face.B,
    faceToBottom: Face.F,
    faceToLeft: Face.D,
  ),
  FaceRelationship(
    visibleFace: Face.D,
    faceToTop: Face.F,
    faceToRight: Face.A,
    faceToBottom: Face.E,
    faceToLeft: Face.C,
  ),
  FaceRelationship(
    visibleFace: Face.E,
    faceToTop: Face.A,
    faceToRight: Face.B,
    faceToBottom: Face.C,
    faceToLeft: Face.D,
  ),
  FaceRelationship(
    visibleFace: Face.F,
    faceToTop: Face.C,
    faceToRight: Face.B,
    faceToBottom: Face.A,
    faceToLeft: Face.D,
  ),
];

///This represents movement directions of a cube.
enum MovementDirection {
  ///
  up,

  ///
  right,

  ///
  down,

  ///
  left,

  ///
}

///Calculate the new cube given the current visible face , movement
///direction and current cube
Cube rollCube({
  required Cube cube,
  required MovementDirection movementDirection,
  //required Angle orientation,
}) {
  final Face newVisibleFace;
  final Angle newOrientation;

  switch (movementDirection) {
    case MovementDirection.up:
      newVisibleFace = calculateCorrectedFaceToBottom(
        visibleFace: cube.visibleFace,
        orientation: cube.orientation,
      );
      newOrientation = cube.orientation + calculateCubeOrientationChange(
        startFace: cube.visibleFace,
        endFace: newVisibleFace,
      );
      break;
    case MovementDirection.right:
      newVisibleFace = calculateCorrectedFaceToLeft(
        visibleFace: cube.visibleFace,
        orientation: cube.orientation,
      );
      newOrientation = cube.orientation + calculateCubeOrientationChange(
        startFace: cube.visibleFace,
        endFace: newVisibleFace,
      );
      break;
    case MovementDirection.down:
      newVisibleFace = calculateCorrectedFaceToTop(
        visibleFace: cube.visibleFace,
        orientation: cube.orientation,
      );
      newOrientation = cube.orientation + calculateCubeOrientationChange(
        startFace: cube.visibleFace,
        endFace: newVisibleFace,
      );
      break;
    case MovementDirection.left:
      newVisibleFace = calculateCorrectedFaceToRight(
        visibleFace: cube.visibleFace,
        orientation: cube.orientation,
      );
      newOrientation = cube.orientation + calculateCubeOrientationChange(
        startFace: cube.visibleFace,
        endFace: newVisibleFace,
      );
      break;
  }

  return Cube(visibleFace: newVisibleFace, orientation: newOrientation.normalized);
}

///Returns the face that will be to the top in a given orientation
Face calculateCorrectedFaceToTop({
  required Face visibleFace,
  required Angle orientation,
}) {
  final intOrientation =
      double.parse(orientation.normalized.toString()).toInt();

  final faceRelationship = faceRelationships.firstWhere(
    (faceRelationship) => faceRelationship.visibleFace == visibleFace,
  );

  switch (intOrientation) {
    case 0:
      return faceRelationship.faceToTop;
    case 90:
      return faceRelationship.faceToLeft;
    case 180:
      return faceRelationship.faceToBottom;
    case 270:
      return faceRelationship.faceToRight;
    default:
      throw Error();
  }
}

///Returns the face that will be to the Right in a given orientation
Face calculateCorrectedFaceToRight({
  required Face visibleFace,
  required Angle orientation,
}) {
  final intOrientation =
      double.parse(orientation.normalized.toString()).toInt();

  final faceRelationship = faceRelationships.firstWhere(
    (faceRelationship) => faceRelationship.visibleFace == visibleFace,
  );

  switch (intOrientation) {
    case 0:
      return faceRelationship.faceToRight;
    case 90:
      return faceRelationship.faceToTop;
    case 180:
      return faceRelationship.faceToLeft;
    case 270:
      return faceRelationship.faceToBottom;
    default:
      throw Error();
  }
}

///Returns the face that will be to the bottom in a given orientation
Face calculateCorrectedFaceToBottom({
  required Face visibleFace,
  required Angle orientation,
}) {
  final intOrientation =
      double.parse(orientation.normalized.toString()).toInt();

  final faceRelationship = faceRelationships.firstWhere(
    (faceRelationship) => faceRelationship.visibleFace == visibleFace,
  );

  switch (intOrientation) {
    case 0:
      return faceRelationship.faceToBottom;
    case 90:
      return faceRelationship.faceToRight;
    case 180:
      return faceRelationship.faceToTop;
    case 270:
      return faceRelationship.faceToLeft;
    default:
      throw Error();
  }
}

///Returns the face that will be to the left in a given orientation
Face calculateCorrectedFaceToLeft({
  required Face visibleFace,
  required Angle orientation,
}) {
  final intOrientation = double.parse(orientation.normalized
          .toString()
          .substring(0, orientation.normalized.toString().length - 1))
      .toInt();

  final faceRelationship = faceRelationships.firstWhere(
    (faceRelationship) => faceRelationship.visibleFace == visibleFace,
  );

  switch (intOrientation) {
    case 0:
      return faceRelationship.faceToLeft;
    case 90:
      return faceRelationship.faceToBottom;
    case 180:
      return faceRelationship.faceToRight;
    case 270:
      return faceRelationship.faceToTop;
    default:
      throw Error();
  }
}
