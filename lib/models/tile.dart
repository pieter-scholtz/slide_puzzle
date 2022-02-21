import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/cube.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

/// {@template tile}
/// Model for a puzzle tile.
/// {@endtemplate}
class Tile extends Equatable {
  /// {@macro tile}
  const Tile({
    required this.value,
    this.cube,
    required this.correctPosition,
    this.previousPosition,
    required this.currentPosition,
    this.isWhitespace = false,
  });

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  ///cube that the tile represents.
  final Cube? cube;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The current 2D [Position] of the [Tile].
  final Position? previousPosition;

  /// The current 2D [Position] of the [Tile].
  final Position currentPosition;

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({
    Position? updatedCurrentPosition,
    Cube? updatedCube,
    Position? updatedPreviousPosition,
  }) {
    return Tile(
      value: value,
      cube: updatedCube ?? cube,
      previousPosition: updatedPreviousPosition ?? previousPosition,
      correctPosition: correctPosition,
      currentPosition: updatedCurrentPosition ?? currentPosition,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhitespace,
      ];
}
