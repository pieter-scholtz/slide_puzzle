import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:very_good_slide_puzzle/audio_control/audio_control.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/dashatar/dashatar.dart';
import 'package:very_good_slide_puzzle/helpers/helpers.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/themes/themes.dart';
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
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  /// The controller that drives [_scale] animation.
  late AnimationController _scaleController;
  late Animation<double> _scale;

  late AnimationController _rotateController;
  late Animation<double> _rotate;

  late AnimationController _positionController;
  late Animation<Offset> _position;

    late AnimationController _position2Controller;
  late Animation<Offset> _position2;

  final Duration _movementDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: _movementDuration,
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _position = Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)).animate(
      //CurvedAnimation(
      //  parent:
      _positionController,
      //  curve: const Interval(0, 1, curve: Curves.easeInOut),
      //),
    );

        _position2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _position2 = Tween<Offset>(begin:Offset(-1, 0) , end: Offset.zero).animate(
      //CurvedAnimation(
      //  parent:
      _position2Controller,
      //  curve: const Interval(0, 1, curve: Curves.easeInOut),
      //),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: _movementDuration,
    );

    _rotate = Tween<double>(begin: 0, end: -pi / 2).animate(
      _rotateController,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();
    final theme = context.select((DashatarThemeBloc bloc) => bloc.state.theme);
    final status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == DashatarPuzzleStatus.started;
    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final canPress = puzzleIncomplete;

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedAlign(
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
              key: Key('dashatar_puzzle_tile_scale_${widget.tile.value}'),
              scale: _scale,
              child: AnimatedBuilder(
                animation: _rotate,
                builder: (context, child) => Stack(
                    //alignment: Alignment.centerRight,
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      SlideTransition(
                          position: _position,
                          child: Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_rotate.value),
                            //(,
                            //alignment: FractionalOffset.centerRight,
                            child: CubeSide(
                                widget: widget,
                                theme: theme,
                                canPress: canPress,
                                rotateController: _rotateController,
                                positionController: _positionController,
                                position2Controller: _position2Controller),
                          )),

                       SlideTransition(
                           position: _position2,
                           child: 
                          Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_rotate.value+(pi/2)),
                              
                            //alignment: FractionalOffset.centerRight,
                            child: CubeSide(
                                widget: widget,
                                theme: theme,
                                canPress: canPress,
                                rotateController: _rotateController,
                                positionController: _positionController,
                                position2Controller: _position2Controller),
                          )
                          )

                      //                   Transform(
                      //   transform: Matrix4.identity()
                      //     ..setEntry(3, 2, 0.003)
                      //     ..rotateY(pi *2 - _rotate.value  ),
                      //   //alignment: FractionalOffset.centerRight,
                      //   child: CubeSide(
                      //       widget: widget,
                      //       theme: theme,
                      //       canPress: canPress,
                      //       rotateController: _rotateController),
                      // ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CubeSide extends StatelessWidget {
  const CubeSide({
    Key? key,
    required this.widget,
    required this.theme,
    required this.canPress,
    required AnimationController rotateController,
    required AnimationController positionController,
    required AnimationController position2Controller,
  })  : _rotateController = rotateController,
        _positionController = positionController, _position2Controller = position2Controller,
        super(key: key);

  final CubePuzzleTile widget;

  final DashatarTheme theme;
  final bool canPress;
  final AnimationController _rotateController;
  final AnimationController _positionController;
  final AnimationController _position2Controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      //padding: EdgeInsets.zero,
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        textStyle: PuzzleTextStyle.headline2.copyWith(
            //fontSize: 20,
            ),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.blue, width: 20, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      onPressed: canPress
          ? () {
              if (_rotateController.status == AnimationStatus.completed) {
                _rotateController.reverse();
                _positionController.reverse();
                _position2Controller.reverse();
              } else {
                _rotateController.forward();
                _positionController.forward();
                _position2Controller.forward();
              }
              //if (kDebugMode) {
                print('hello');
              //}

              context.read<PuzzleBloc>().add(TileTapped(widget.tile));
            }
          : null,
      child: Text(
        widget.tile.value.toString(),
        semanticsLabel: context.l10n.puzzleTileLabelText(
          widget.tile.value.toString(),
          widget.tile.currentPosition.x.toString(),
          widget.tile.currentPosition.y.toString(),
        ),
      ),
    );
  }
}
