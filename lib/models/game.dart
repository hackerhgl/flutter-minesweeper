import 'package:minesweeper/engine/engine.dart';
import 'package:minesweeper/models/location.dart';
import 'package:minesweeper/types/engine.dart';

class Game {
  final int minesCount;
  final int rows;
  final int columns;

  final Grid grid;

  final List<Location> flags;
  final List<Location> moves;

  final bool didWin;
  final bool gameOver;

  Game({
    required this.minesCount,
    required this.rows,
    required this.columns,
    required this.flags,
    required this.moves,
    required this.didWin,
    required this.gameOver,
f  });
}
