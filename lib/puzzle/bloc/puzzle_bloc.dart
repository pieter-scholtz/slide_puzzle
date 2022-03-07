// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:angles/angles.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/cube.dart';
import 'package:very_good_slide_puzzle/models/cube_faces.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  late List<Tile> _moves = [];

  final int _size;

  final Random? random;

  late bool isShuffling = false;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _resetPuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
    print("puzzle init");
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        if (isShuffling == false) {_moves.add(tappedTile);}
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete() && !isShuffling) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.score + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.score + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
    print("Tile Tapped");
    print(_moves);
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) async {
    //final puzzle = _resetPuzzle(_size);
    isShuffling = true;

    final someMoves = _moves;
    _moves = [];

    for (var i = someMoves.length - 1; i >= 0; i--) {
      print(someMoves[i]);

      await Future.delayed(const Duration(milliseconds: 300), () {
        this.add(TileTapped(
          state.puzzle.tiles
              .singleWhere((tile) => tile.value == someMoves[i].value),
        ));
      });
    }

    // emit(
    //   PuzzleState(
    //     puzzle: puzzle.sort(),
    //     numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
    //   ),
    // );
    await Future.delayed(const Duration(milliseconds: 100), () {
      isShuffling = false;
    });
  }

  Puzzle _resetPuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    //TODO: hardcode this perhaps ?

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            cube:
                const Cube(visibleFace: Face.A, orientation: Angle.degrees(0)),
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            cube:
                const Cube(visibleFace: Face.A, orientation: Angle.degrees(0)),
            previousPosition: currentPositions[i - 1],
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }
}
