import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
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

  late AnimationController _movementController;


  late Animation<double> _face1YRotation =
      Tween<double>(begin: 0, end: 0).animate(
    _movementController,
  );

  late Animation<double> _face2YRotation =
      Tween<double>(begin: 0, end: 0).animate(
    _movementController,
  );

  late Animation<double> _face1XRotation =
      Tween<double>(begin: 0, end: 0).animate(
    _movementController,
  );

  late Animation<double> _face2XRotation =
      Tween<double>(begin: 0, end: 0).animate(
    _movementController,
  );

  late Animation<Offset> _face1Position = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  ).animate(_movementController);

  late Animation<Offset> _face2Position = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  ).animate(_movementController);

  final Duration _movementDuration = const Duration(milliseconds: 400);

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

    _scale = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    _movementController = AnimationController(
      vsync: this,
      duration: _movementDuration,
    );
  }

  @override
  void didUpdateWidget(CubePuzzleTile oldWidget) {
    if (!((widget.tile.currentPosition.x == oldWidget.tile.currentPosition.x) &&
        (widget.tile.currentPosition.y == oldWidget.tile.currentPosition.y))) {
      _movementController.reset();

      _face1Position = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(
          (widget.tile.currentPosition.x - widget.tile.previousPosition!.x)
              .toDouble(),
          (widget.tile.currentPosition.y - widget.tile.previousPosition!.y)
              .toDouble(),
        ),
      ).animate(
        _movementController,
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
        _movementController,
      );

      _face1Value = faceValues[oldWidget.tile.value]
          [oldWidget.tile.cube!.visibleFace.index];

      _face2Value =
          faceValues[widget.tile.value][widget.tile.cube!.visibleFace.index];

      if (widget.tile.currentPosition.x > oldWidget.tile.currentPosition.x) {
//        print(widget.tile.value.toString() + "movedRight");

        _face1PositionAlignment = Alignment.centerLeft;

        _face2PositionAlignment = Alignment.centerRight;

        _face1YRotation = Tween<double>(begin: 0, end: -pi / 2).animate(
          _movementController,
        );

        _face2YRotation = Tween<double>(begin: pi / 2, end: 0).animate(
          _movementController,
        );

        _face1XRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _face2XRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _movementController.forward();
      }

      if (widget.tile.currentPosition.x < oldWidget.tile.currentPosition.x) {
//        print(widget.tile.value.toString() + "movedLeft");

        _face1PositionAlignment = Alignment.centerRight;

        _face2PositionAlignment = Alignment.centerLeft;

        _face1YRotation = Tween<double>(begin: 0, end: pi / 2).animate(
          _movementController,
        );

        _face2YRotation = Tween<double>(begin: -pi / 2, end: 0).animate(
          _movementController,
        );

        _face1XRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _face2XRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _movementController.forward();
      }

      if (widget.tile.currentPosition.y > oldWidget.tile.currentPosition.y) {
//        print(widget.tile.value.toString() + "movedDown");

        _face1PositionAlignment = Alignment.topCenter;

        _face2PositionAlignment = Alignment.bottomCenter;

        _face1XRotation = Tween<double>(begin: 0, end: pi / 2).animate(
          _movementController,
        );

        _face2XRotation = Tween<double>(begin: -pi / 2, end: 0).animate(
          _movementController,
        );

        _face1YRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _face2YRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _movementController.forward();
      }

      if (widget.tile.currentPosition.y < oldWidget.tile.currentPosition.y) {
//        print(widget.tile.value.toString() + "movedUp");

        _face1PositionAlignment = Alignment.bottomCenter;

        _face2PositionAlignment = Alignment.topCenter;

        _face1XRotation = Tween<double>(begin: 0, end: -pi / 2).animate(
          _movementController,
        );

        _face2XRotation = Tween<double>(begin: pi / 2, end: 0).animate(
          _movementController,
        );

        _face1YRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _face2YRotation = Tween<double>(begin: 0, end: 0).animate(
          _movementController,
        );

        _movementController.forward();
      }

      // print(
      //     "Visible value :${faceValues[widget.tile.value][widget.tile.cube!.visibleFace.index]}");
    }

    super.didUpdateWidget(widget);
  }

  @override
  void dispose() {
    _movementController.dispose();
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
                          text: _face1Value.toString(),
                          tile: widget.tile,
                          state:widget.state,
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
                          text: _face2Value.toString(),
                          tile: widget.tile,
                           state:widget.state,
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
  const CubeFace({
    Key? key,
    required this.text,
    required this.tile,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  final String text;

  final Tile tile;

    /// The state of the puzzle.
  final PuzzleState state;

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: PuzzleTextStyle.headline2.copyWith(color: Colors.black),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
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
