import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/cube_movement.dart';
import 'package:very_good_slide_puzzle/models/face_values.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/bloc/theme_bloc.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

abstract class _TileSize {
  static double small = 75;
  static double medium = 100;
  static double large = 112;
}

/// {@template dashatar_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class CubePuzzleTile extends StatefulWidget {
  /// {@macro dashatar_puzzle_tile}
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

  final rotationCurve = Curves.linear;
  final positionCurve = Curves.easeInSine;

  late Animation<double> _face1YRotation =
      Tween<double>(begin: 0, end: 0).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<double> _face2YRotation =
      Tween<double>(begin: 0, end: 0).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<double> _face1XRotation =
      Tween<double>(begin: 0, end: 0).animate(
    CurvedAnimation(
      parent: movementController,
      curve: rotationCurve,
    ),
  );

  late Animation<double> _face2XRotation =
      Tween<double>(begin: 0, end: 0).animate(
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

  final Duration _movementDuration = const Duration(milliseconds: 444);

  late int _face1Value =
      faceValues[widget.tile.value][widget.tile.cube!.visibleFace.index];

  late int _face2Value =
      faceValues[widget.tile.value][widget.tile.cube!.visibleFace.index];

  late AlignmentGeometry _face1PositionAlignment = Alignment.center;

  late AlignmentGeometry _face2PositionAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();

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

    movementController = AnimationController(
      vsync: this,
      duration: _movementDuration,
    );
  }

  @override
  void didUpdateWidget(CubePuzzleTile oldWidget) {
    movementDirection = MovementDirection.none;
    if (!((widget.tile.currentPosition.x == oldWidget.tile.currentPosition.x) &&
        (widget.tile.currentPosition.y == oldWidget.tile.currentPosition.y))) {
      movementController.reset();

      _face1Position = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(
          (widget.tile.currentPosition.x - widget.tile.previousPosition!.x)
              .toDouble(),
          (widget.tile.currentPosition.y - widget.tile.previousPosition!.y)
              .toDouble(),
        ),
      ).animate(
        CurvedAnimation(
          parent: movementController,
          curve: positionCurve,
        ),
      );

      _face2Position = Tween<Offset>(
        begin: Offset(
          (widget.tile.currentPosition.x - widget.tile.previousPosition!.x)
                  .toDouble() *
              -1,
          (widget.tile.currentPosition.y - widget.tile.previousPosition!.y)
                  .toDouble() *
              -1,
        ),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: movementController,
          curve: positionCurve,
        ),
      );

      _face1Value = faceValues[oldWidget.tile.value]
          [oldWidget.tile.cube!.visibleFace.index];

      _face2Value =
          faceValues[widget.tile.value][widget.tile.cube!.visibleFace.index];

      if (widget.tile.currentPosition.x > oldWidget.tile.currentPosition.x) {
//        print(widget.tile.value.toString() + "movedRight");
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

        movementController.forward();
      }

      if (widget.tile.currentPosition.x < oldWidget.tile.currentPosition.x) {
//        print(widget.tile.value.toString() + "movedLeft");
        movementDirection = MovementDirection.left;

        _face1PositionAlignment = Alignment.centerRight;

        _face2PositionAlignment = Alignment.centerLeft;

        _face1YRotation = Tween<double>(begin: 0, end: pi / 2).animate(
          movementController,
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

        movementController.forward();
      }

      if (widget.tile.currentPosition.y > oldWidget.tile.currentPosition.y) {
//        print(widget.tile.value.toString() + "movedDown");
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

        movementController.forward();
      }

      if (widget.tile.currentPosition.y < oldWidget.tile.currentPosition.y) {
//        print(widget.tile.value.toString() + "movedUp");
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

        movementController.forward();
      }

      // print(
      //     "Visible value :${faceValues[widget.tile.value][widget.tile.cube!.visibleFace.index]}");
    }

    super.didUpdateWidget(widget);
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

    final canPress = puzzleIncomplete;

    return AnimatedAlign(
      alignment: FractionalOffset(
        (widget.tile.currentPosition.x - 1) / (size - 1),
        (widget.tile.currentPosition.y - 1) / (size - 1),
      ),
      duration: _movementDuration,
      curve: Curves.easeInOut,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_small_${widget.tile.value}'),
          dimension: _TileSize.small,
          child: child,
        ),
        medium: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_medium_${widget.tile.value}'),
          dimension: _TileSize.medium,
          child: child,
        ),
        large: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_large_${widget.tile.value}'),
          dimension: _TileSize.large,
          child: child,
        ),
        child: (_) => MouseRegion(
          onEnter: (_) {
            if (canPress) {
              _scaleController.forward();
            }
          },
          onExit: (_) {
            if (canPress) {
              _scaleController.reverse();
            }
          },
          child: ScaleTransition(
            key: Key('simple_puzzle_tile_scale_${widget.tile.value}'),
            scale: _scale,
            child: AnimatedBuilder(
              animation: _face1YRotation,
              builder: (context, child) => Stack(
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
                          text: _face1Value.toString(),
                          tile: widget.tile,
                          state: widget.state,
                          onPressed: () {
                            if (canPress) {
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
                          text: _face2Value.toString(),
                          tile: widget.tile,
                          state: widget.state,
                          onPressed: () {
                            if (canPress) {
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
    );
  }
}

class CubeFace extends StatelessWidget {
  const CubeFace(
      {Key? key,
      required this.text,
      required this.tile,
      required this.state,
      required this.onPressed,
      required this.movementDirection,
      required this.movementController,
      required this.is1})
      : super(key: key);

  final String text;

  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  final Function() onPressed;

  final MovementDirection movementDirection;

  final AnimationController movementController;

  final bool is1;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    Radius topLeft = Radius.circular(12);
    Radius topRight = Radius.circular(12);
    Radius bottomLeft = Radius.circular(12);
    Radius bottomRight = Radius.circular(12);

    if ( movementController.value < 0.9) {
      switch (movementDirection) {
        case MovementDirection.right:
        print('Right');
          topRight = is1 ? Radius.circular(12) : Radius.zero;
          bottomRight = is1 ? Radius.circular(12) : Radius.zero;
          topLeft = is1 ? Radius.zero : Radius.circular(12);
          bottomLeft = is1 ? Radius.zero : Radius.circular(12);
          break;
        case MovementDirection.down:
          topRight = Radius.zero;
          bottomRight = Radius.zero;
          topLeft = Radius.zero;
          bottomLeft = Radius.zero;
          break;
        case MovementDirection.left:
          topRight = Radius.zero;
          bottomRight = Radius.zero;
          topLeft = Radius.zero;
          bottomLeft = Radius.zero;
          break;
        case MovementDirection.up:
          topRight = Radius.zero;
          bottomRight = Radius.zero;
          topLeft = Radius.zero;
          bottomLeft = Radius.zero;
          break;
        default:
          break;
      }
    }
    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: PuzzleTextStyle.headline2
            .copyWith(color: Colors.black, fontSize: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: topLeft,
              topRight: topRight,
              bottomLeft: bottomLeft,
              bottomRight: bottomRight),
        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (tile.value == state.lastTappedTile?.value) {
              return theme.pressedColor;
            } else if (states.contains(MaterialState.hovered)) {
              return theme.hoverColor;
            } else {
              return theme.defaultColor;
            }
          },
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        semanticsLabel: context.l10n.puzzleTileLabelText(
          tile.value.toString(),
          tile.currentPosition.x.toString(),
          tile.currentPosition.y.toString(),
        ),
      ),
    );
  }
}
