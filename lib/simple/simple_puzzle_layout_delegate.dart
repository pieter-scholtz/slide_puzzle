import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/constants/face_values.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/constants/sizes.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/simple/cube_puzzle_tile.dart';
import 'package:very_good_slide_puzzle/simple/simple.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      rpi: (_, child) => child!,
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => state.puzzle.isComplete()
                ? const SimplePuzzleShuffleButton()
                : const SimplePuzzleResetButton(),
          medium: (_, child) => state.puzzle.isComplete()
                ? const SimplePuzzleShuffleButton()
                : const SimplePuzzleResetButton(),
          large: (_, __) => const SizedBox(),
          rpi: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/kdab_labs_small.png',
            key: const Key('kdab_labs_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/kdab_labs_small.png',
            key: const Key('kdab_labs_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: 333,
            height: 333,
            child: Image.asset(
              'assets/images/kdab_labs_small.png',
              key: const Key('kdab_labs_large'),
            ),
          ),
        ),
        rpi: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: 130,
            height: 180,
            child: Image.asset(
              'assets/images/kdab_labs_small.png',
              key: const Key('kdab_labs_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('cube_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('cube_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('cube_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
          rpi: (_, __) => SizedBox.square(
            dimension: _BoardSize.rpi,
            child: SimplePuzzleBoard(
              key: const Key('cube_puzzle_board_rpi'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return CubePuzzleTile(
      tile: tile,
      state: state,
    );
  }

  @override
  Widget whitespaceTileBuilder(Tile tile, PuzzleState state) {
    final whiteSpace = IgnorePointer(
        ignoring: state.puzzleStatus == PuzzleStatus.complete,
        child: Align(
            alignment: FractionalOffset(
              (tile.currentPosition.x - 1) / (4 - 1),
              (tile.currentPosition.y - 1) / (4 - 1),
            ),
            child: ResponsiveLayoutBuilder(
              small: (_, child) => SizedBox.square(
                dimension: TileSize.small,
                child: child,
              ),
              medium: (_, child) => SizedBox.square(
                dimension: TileSize.medium,
                child: child,
              ),
              large: (_, child) =>
                  SizedBox.square(dimension: TileSize.large, child: child),
              rpi: (_, child) =>
                  SizedBox.square(dimension: TileSize.rpi, child: child),
              child: (_) => TextButton(
                child: Text(""),
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor:
                      faceColors[state.puzzle.tiles[0].cube!.visibleFace.index],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            )));

    return AnimatedSwitcher(
        switchOutCurve: const Interval(0.5, 1, curve: Curves.linear),
        switchInCurve: const Interval(0.5, 1, curve: Curves.linear),
        duration: Duration(milliseconds: 1000),
        child: state.puzzleStatus == PuzzleStatus.incomplete
            ? const SizedBox()
            : whiteSpace);
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
          rpi:30
        ),
        const ResponsiveGap(
          large: 32,
          small: 16,
        ),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
          rpi: 12,
        ),
        IgnorePointer(
          ignoring: state.isBusy && !state.puzzle.isComplete(),
          child: ResponsiveLayoutBuilder(
            small: (_, __) => const SizedBox(),
            medium: (_, __) => const SizedBox(),
            large: (_, __) => state.puzzle.isComplete()
                ? const SimplePuzzleShuffleButton()
                : const SimplePuzzleResetButton(),
            rpi: (_, __) => state.puzzle.isComplete()
                ? const SimplePuzzleShuffleButton()
                : const SimplePuzzleResetButton(),
          ),
        )
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The status of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      key: puzzleTitleKey,
      title:
          context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
  static double rpi = 200;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: tiles,
    );
  }
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AnimatedSlide(
      offset: const Offset(0, 0),
      duration: const Duration(milliseconds: 100),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: PuzzleColors.white,
          textStyle: PuzzleTextStyle.headline2.copyWith(
            fontSize: tileFontSize,
          ),
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
        onPressed: state.puzzleStatus == PuzzleStatus.incomplete
            ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
            : null,
        child: Text(
          tile.value.toString(),
          semanticsLabel: context.l10n.puzzleTileLabelText(
            tile.value.toString(),
            tile.currentPosition.x.toString(),
            tile.currentPosition.y.toString(),
          ),
        ),
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleResetButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/reset_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleReset),
        ],
      ),
    );
  }
}

class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_start_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleShuffle()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}
