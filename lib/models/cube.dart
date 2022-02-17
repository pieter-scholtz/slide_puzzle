import 'package:angles/angles.dart';
import 'package:very_good_slide_puzzle/models/cube_faces.dart';

///Class describing a cube
class Cube {
  ///Movement rule constructor
  const Cube({
    required this.visibleFace,
    required this.orientation,
  });

  ///side facing towards the user
  final Face visibleFace;

  ///Current of the visible side (or the cube , since are at 0 degrees if the 
  ///cube is flattened)
  final Angle orientation;
}
