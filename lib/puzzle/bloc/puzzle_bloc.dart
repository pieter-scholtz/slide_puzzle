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
    on<PuzzleShuffle>(_onPuzzleShuffle);
  }

  late List<int> _moves = [];

  final int _size;

  final Random? random;

  //late bool isRes

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _initializePuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        _moves.add(tappedTile.value);
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
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
        //emit(
        //  state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        //);
      }
    } else {
      //emit(
      //  state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      //);
    }
    print(_moves);
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) async {
    emit(
      state.copyWith(isBusy: true),
    );

    final _movesCopy = _moves;
    _moves = [];

    for (var i = _movesCopy.length - 1; i >= 0; i--) {
      print(_movesCopy[i]);

      await Future.delayed(const Duration(milliseconds: 300), () {
        this.add(TileTapped(
          state.puzzle.tiles.singleWhere((tile) => tile.value == _movesCopy[i]),
        ));
      });
    }

    await Future.delayed(const Duration(milliseconds: 600), () {
      emit(
        state.copyWith(isBusy: false),
      );
    });

    _moves = [];
  }

  void _onPuzzleShuffle(PuzzleShuffle event, Emitter<PuzzleState> emit) async {
    emit(
      state.copyWith(isBusy: true, puzzleStatus: PuzzleStatus.incomplete),
    );

    List<int> shuffleMoves = [15,14,13];

    for (var i = 0; i <= shuffleMoves.length - 1; i++) {
      print(shuffleMoves[i]);

      await Future.delayed(const Duration(milliseconds: 300), () {
        this.add(TileTapped(
          state.puzzle.tiles
              .singleWhere((tile) => tile.value == shuffleMoves[i]),
        ));
      });
    }
    await Future.delayed(const Duration(milliseconds: 600), () {
      emit(
        state.copyWith(isBusy: false),
      );
    });
  }

  Puzzle _initializePuzzle(int size, {bool shuffle = true}) {
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


    // final someMoves = [
    //   12,
    //   15,
    //   11,
    //   12,
    //   15,
    //   14,
    //   13,
    //   6,
    //   5,
    //   3,
    //   4,
    //   7,
    //   8,
    //   4,
    //   3,
    //   2,
    //   1,
    //   5,
    //   6,
    //   10,
    //   9,
    //   13,
    //   14,
    //   15
    // ];


    // final shuffleMoves = [
    //   15,
    //   14,
    //   13,
    //   9,
    //   10,
    //   11,
    //   12,
    //   8,
    //   7,
    //   6,
    //   5,
    //   1,
    //   2,
    //   3,
    //   4,
    //   7,
    //   6,
    //   4,
    //   7,
    //   6,
    //   4,
    //   7,
    //   6,
    //   4,
    //   7,
    //   5,
    //   1,
    //   10,
    //   11,
    //   1,
    //   10,
    //   11,
    //   1,
    //   10,
    //   11,
    //   1,
    //   10,
    //   13,
    //   9,
    //   10,
    //   13,
    //   12,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   8,
    //   12,
    //   13,
    //   10,
    //   9,
    //   13,
    //   10,
    //   9,
    //   13,
    //   14,
    //   15,
    //   8,
    //   7,
    //   5,
    //   12,
    //   7,
    //   5,
    //   12,
    //   7,
    //   5,
    //   12,
    //   7,
    //   5,
    //   15,
    //   8,
    //   12,
    //   15,
    //   8,
    //   12,
    //   15,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   5,
    //   8,
    //   7,
    //   15,
    //   12,
    //   7,
    //   15,
    //   5,
    //   8,
    //   15,
    //   5,
    //   8,
    //   15,
    //   5,
    //   8,
    //   15,
    //   5,
    //   8,
    //   15,
    //   5,
    //   8,
    //   15,
    //   5,
    //   12,
    //   7,
    //   5,
    //   10,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   9,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   9,
    //   14,
    //   13,
    //   5,
    //   10,
    //   13,
    //   5,
    //   9,
    //   14,
    //   5,
    //   9,
    //   14,
    //   5,
    //   9,
    //   14,
    //   5,
    //   9,
    //   14,
    //   5,
    //   10,
    //   13,
    //   5,
    //   14,
    //   14,
    //   5,
    //   12,
    //   7,
    //   13,
    //   12,
    //   7,
    //   13,
    //   13,
    //   13,
    //   12,
    //   7,
    //   5,
    //   14,
    //   9,
    //   10,
    //   14,
    //   9,
    //   10,
    //   14,
    //   9,
    //   10,
    //   14,
    //   9,
    //   7,
    //   12,
    //   13,
    //   5,
    //   12,
    //   13,
    //   5,
    //   12,
    //   13,
    //   5,
    //   12,
    //   13,
    //   5,
    //   12,
    //   13,
    //   13,
    //   12,
    //   7,
    //   9,
    //   14,
    //   10,
    //   5,
    //   13,
    //   12,
    //   7,
    //   9,
    //   14,
    //   10,
    //   5,
    //   13,
    //   12,
    //   7,
    //   9,
    //   14,
    //   10,
    //   5,
    //   13,
    //   12,
    //   7,
    //   9,
    //   14,
    //   10,
    //   5,
    //   13,
    //   12,
    //   7,
    //   9,
    //   9,
    //   9,
    //   14,
    //   10,
    //   5,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   5,
    //   9,
    //   12,
    //   5,
    //   7,
    //   13,
    //   5,
    //   7,
    //   13,
    //   5,
    //   7,
    //   13,
    //   5,
    //   7,
    //   13,
    //   12,
    //   12,
    //   13,
    //   13,
    //   12,
    //   9,
    //   5,
    //   12,
    //   13,
    //   7,
    //   7,
    //   13,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   9,
    //   5,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   13,
    //   7,
    //   12,
    //   12,
    //   7,
    //   7,
    //   5,
    //   9,
    //   12,
    //   5,
    //   9,
    //   12,
    //   5,
    //   9,
    //   7
    // ];