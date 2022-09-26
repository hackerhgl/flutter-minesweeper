part of 'engine.dart';

class _Calculate {
  static Grid neighbors(Grid grid) {
    final newGrid = [...grid];
    final columns = grid.length;
    final rows = grid.length;

    final maxColumns = columns - 1;
    final maxRows = rows - 1;

    for (var y = 0; y < columns; y++) {
      for (var x = 0; x < rows; x++) {
        //
        final cell = grid[y][x];
        if (cell.isBomb) {
          continue;
        }
        var count = 0;
        for (var yi = max(y - 1, 0); yi < min(maxColumns, y + 1); yi++) {
          for (var xi = max(x - 1, 0); xi < min(maxRows, x + 1); xi++) {
            //
            final neighbor = grid[yi][xi];
            if (neighbor.isBomb) {
              count++;
            }
          }
        } // neighbor loop end
        newGrid[y][x] = cell.copyWith(
          count: count,
        );
      }
    } // cell loop end
    return newGrid;
  }
}
