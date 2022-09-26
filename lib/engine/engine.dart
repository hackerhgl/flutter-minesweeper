import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:minesweeper/models/cell.dart';
import 'package:minesweeper/types/engine.dart';

part '_generate.dart';
part '_calculate.dart';

class Engine {
  static void init() {
    _Generate.init();
  }

  static Grid floodFill(int x, int y, Grid grid) {
    final cell = grid[y][x];
    if (cell.isBomb) {
      return grid;
    }
    if (cell.isRevealed) {
      return grid;
    }
    grid[y][x] = cell.copyWith(isRevealed: true);
    if (cell.count == 0) {
      for (var yi = max(y - 1, 0); yi < min(grid.length, y + 2); yi++) {
        for (var xi = max(x - 1, 0); xi < min(grid.length, x + 2); xi++) {
          return floodFill(xi, yi, grid);
        }
      }
    }
    return grid;
  }

  static bool didWin(Grid grid) {
    for (var y = 0; y < grid.length; y++) {
      for (var x = 0; x < grid.length; x++) {
        final cell = grid[y][x];
        if (!cell.isRevealed && !cell.isBomb) {
          return false;
        }
      }
    }
    return true;
  }
}
