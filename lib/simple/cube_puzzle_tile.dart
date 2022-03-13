import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/cube.dart';
import 'package:very_good_slide_puzzle/models/cube_movement.dart';
import 'package:very_good_slide_puzzle/models/face_values.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/models/sizes.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';

/// {@template cube_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class CubePuzzleTile extends StatefulWidget {
  /// {@macro cube_puzzle_tile}
  const CubePuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  State<CubePuzzleTile> createState() => CubePuzzleTileState();
}

/// The state of [CubePuzzleTile].
@visibleForTesting
class CubePuzzleTileState extends State<CubePuzzleTile>
    with TickerProviderStateMixin {
  /// The controller that drives [_scale] animation.
  late AnimationController _scaleController;
  late Animation<double> _scale;

  late AnimationController movementController;

  late MovementDirection movementDirection = MovementDirection.none;

  final rotationCurve =
      const Interval(0.2, 0.8, curve: Curves.linear); //Curves.linear; //
  final positionCurve =
      const Interval(0.2, 0.8, curve: Curves.easeOut); //Curves.easeOut; //

  late Animation<double> _face1YRotation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<double> _face2YRotation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<double> _face1XRotation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<double> _face2XRotation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<Offset> _face1Position = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  ).animate(movementController);

  late Animation<Offset> _face2Position = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  ).animate(movementController);

  final Duration _movementDuration = const Duration(milliseconds: 555);

  late Color _face1Color =
      faceColors[widget.tile.value][widget.tile.cube!.visibleFace.index];

  late Color _face2color =
      faceColors[widget.tile.value][widget.tile.cube!.visibleFace.index];

  late AlignmentGeometry _face1PositionAlignment = Alignment.center;

  late AlignmentGeometry _face2PositionAlignment = Alignment.center;

  late bool isNextToWhitespace = false;

  late bool needsToMove = false;

  late bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    movementController = AnimationController(
      vsync: this,
      duration: _movementDuration,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: _movementDuration,
    );

    _scale = Tween<double>(begin: 1, end: 1).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    if (isNextToWhitespace) {
      needsToMove = true;
    } else {
      needsToMove = false;
    }

    calculateAnimantionValues(
        widget.state.puzzle.tiles
            .firstWhere((tile) => tile.isWhitespace)
            .currentPosition,
        widget.tile.currentPosition,
        widget.tile.cube!);
  }

  @override
  void didUpdateWidget(CubePuzzleTile oldWidget) {
    movementDirection = MovementDirection.none;

    //print(widget.tile.value.toString() + "didUpdate");

    Tile whitespaceTile =
        widget.state.puzzle.tiles.firstWhere((tile) => tile.isWhitespace);

    Position whitespacePosition = whitespaceTile.currentPosition;

    Position currentPosition = widget.tile.currentPosition;

    isNextToWhitespace =
        (((currentPosition.x - whitespacePosition.x).abs() == 1) &&
                ((currentPosition.y - whitespacePosition.y).abs() == 0)) ||
            (((currentPosition.y - whitespacePosition.y).abs() == 1) &&
                ((currentPosition.x - whitespacePosition.x).abs() == 0));

    if (!((currentPosition.x == oldWidget.tile.currentPosition.x) &&
        (currentPosition.y == oldWidget.tile.currentPosition.y))) {
      needsToMove = true;
    }

    if (!needsToMove) {
      calculateAnimantionValues(
          whitespacePosition, widget.tile.currentPosition, widget.tile.cube!);
    }

    if (needsToMove) {
      isAnimating = true;
      movementController.forward().whenComplete(() {
        calculateAnimantionValues(
            whitespacePosition, widget.tile.currentPosition, widget.tile.cube!);
        movementController.reset();
        isAnimating = false;
      });
      needsToMove = false;
    }

    super.didUpdateWidget(widget);
  }

  void calculateAnimantionValues(
      Position whitespacePosition, Position currentPosition, Cube cube) {

    isNextToWhitespace =
        (((currentPosition.x - whitespacePosition.x).abs() == 1) &&
                ((currentPosition.y - whitespacePosition.y).abs() == 0)) ||
            (((currentPosition.y - whitespacePosition.y).abs() == 1) &&
                ((currentPosition.x - whitespacePosition.x).abs() == 0));

    if (isNextToWhitespace) {
      _face1Position = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(
          (whitespacePosition.x - currentPosition.x).toDouble(),
          (whitespacePosition.y - currentPosition.y).toDouble(),
        ),
      ).animate(
        CurvedAnimation(
          parent: movementController,
          curve: positionCurve,
        ),
      );

      _face2Position = Tween<Offset>(
        begin: Offset(
          (whitespacePosition.x - currentPosition.x).toDouble() * -1,
          (whitespacePosition.y - currentPosition.y).toDouble() * -1,
        ),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: movementController,
          curve: positionCurve,
        ),
      );

      if (whitespacePosition.x > currentPosition.x) {
        //print(widget.tile.value.toString() + "can move right");
        movementDirection = MovementDirection.right;

        _face1PositionAlignment = Alignment.centerLeft;

        _face2PositionAlignment = Alignment.centerRight;

        _face1YRotation = Tween<double>(begin: 0, end: -pi / 2).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2YRotation = Tween<double>(begin: pi / 2, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face1XRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2XRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );
      }

      if (whitespacePosition.x < currentPosition.x) {
        //print(widget.tile.value.toString() + "can move left");
        movementDirection = MovementDirection.left;

        _face1PositionAlignment = Alignment.centerRight;

        _face2PositionAlignment = Alignment.centerLeft;

        _face1YRotation = Tween<double>(begin: 0, end: pi / 2).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2YRotation = Tween<double>(begin: -pi / 2, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face1XRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2XRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );
      }

      if (whitespacePosition.y > currentPosition.y) {
        //print(widget.tile.value.toString() + "can move down");
        movementDirection = MovementDirection.down;

        _face1PositionAlignment = Alignment.topCenter;

        _face2PositionAlignment = Alignment.bottomCenter;

        _face1XRotation = Tween<double>(begin: 0, end: pi / 2).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2XRotation = Tween<double>(begin: -pi / 2, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face1YRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2YRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );
      }

      if (whitespacePosition.y < currentPosition.y) {
        //print(widget.tile.value.toString() + "can move up");
        movementDirection = MovementDirection.up;

        _face1PositionAlignment = Alignment.bottomCenter;

        _face2PositionAlignment = Alignment.topCenter;

        _face1XRotation = Tween<double>(begin: 0, end: -pi / 2).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2XRotation = Tween<double>(begin: pi / 2, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face1YRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );

        _face2YRotation = Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(
            parent: movementController,
            curve: rotationCurve,
          ),
        );
      }

      _face1Color = faceColors[widget.tile.value][cube.visibleFace.index];

      Cube rolledcube = rollCube(
          cube: widget.tile.cube!, movementDirection: movementDirection);

      _face2color = faceColors[widget.tile.value][rolledcube.visibleFace.index];
    }
  }

  @override
  void dispose() {
    movementController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();
    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;
    final isComplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzle.isComplete()) == false;
         final isBusy =
        context.select((PuzzleBloc bloc) => bloc.state.isBusy) == true;    

    return IgnorePointer(
      ignoring: !isNextToWhitespace || !puzzleIncomplete || !isComplete || isBusy ,
      child: AnimatedAlign(
        alignment: FractionalOffset(
          (widget.tile.currentPosition.x - 1) / (size - 1),
          (widget.tile.currentPosition.y - 1) / (size - 1),
        ),
        duration: _movementDuration,
        curve: Curves.easeInOut,
        child: ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox.square(
            key: Key('dashatar_puzisCompletezle_tile_small_${widget.tile.value}'),
            dimension: TileSize.small,
            child: child,
          ),
          medium: (_, child) => SizedBox.square(
            key: Key('dashatar_puzzle_tile_medium_${widget.tile.value}'),
            dimension: TileSize.medium,
            child: child,
          ),
          large: (_, child) => SizedBox.square(
            key: Key('dashatar_puzzle_tile_large_${widget.tile.value}'),
            dimension: TileSize.large,
            child: child,
          ),
          child: (_) => AnimatedBuilder(
            animation: _face1YRotation,
            builder: (context, child) => MouseRegion(
              onEnter: (_) {
                if (!isAnimating && puzzleIncomplete) {
                  movementController.animateTo(0.3);
                }
              },
              onExit: (_) {
                if (!isAnimating && puzzleIncomplete) {
                  movementController.reverse();
                }
              },
              child: ScaleTransition(
                key: Key('simple_puzzle_tile_scale_${widget.tile.value}'),
                scale: _scale,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    SlideTransition(
                      position: _face1Position,
                      child: Transform(
                        alignment: _face1PositionAlignment,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_face1YRotation.value)
                          ..rotateX(_face1XRotation.value),
                        child: CubeFace(
                            is1: true,
                            movementController: movementController,
                            movementDirection: movementDirection,
                            color: _face1Color,
                            tile: widget.tile,
                            state: widget.state,
                            onPressed: () {
                              if (puzzleIncomplete) {
                                context
                                    .read<PuzzleBloc>()
                                    .add(TileTapped(widget.tile));
                              }
                            }),
                      ),
                    ),
                    SlideTransition(
                      position: _face2Position,
                      child: Transform(
                        alignment: _face2PositionAlignment,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_face2YRotation.value)
                          ..rotateX(_face2XRotation.value),
                        child: CubeFace(
                            is1: false,
                            movementController: movementController,
                            movementDirection: movementDirection,
                            color: _face2color,
                            tile: widget.tile,
                            state: widget.state,
                            onPressed: () {
                              if (puzzleIncomplete) {
                                context
                                    .read<PuzzleBloc>()
                                    .add(TileTapped(widget.tile));
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CubeFace extends StatelessWidget {
  const CubeFace(
      {Key? key,
      required this.color,
      required this.tile,
      required this.state,
      required this.onPressed,
      required this.movementDirection,
      required this.movementController,
      required this.is1})
      : super(key: key);

  final Color color;

  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  final Function() onPressed;

  final MovementDirection movementDirection;

  final AnimationController movementController;

  final bool is1;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        "",//tile.value.toString(),
        style: TextStyle(color: Colors.white70),
        semanticsLabel: context.l10n.puzzleTileLabelText(
          tile.value.toString(),
          tile.currentPosition.x.toString(),
          tile.currentPosition.y.toString(),
        ),
      ),
    );
  }
}