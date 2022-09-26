part of 'engine.dart';

class _Generate {
  static late final Random _r;

  static void init([seed = 0]) {
    _r = Random(seed);
  }

  Grid board(int rows, int columns) {
    final minesCount = ((rows * columns) * .20).toInt();
    final mines = _Generate.mines(minesCount, rows, columns);
    final grid = _emptyBoard(rows, columns);

    for (final mine in mines) {
      final y = mine[0];
      final x = mine[1];
      grid[y][x] = grid[y][x].copyWith(
        isBomb: true,
      );
    }

    final calculated = _Calculate.neighbors(grid);

    return calculated;
  }

  static Grid _emptyBoard(int rows, int columns) {
    return List.generate(
      rows,
      (y) => List.generate(
        columns,
        (x) => Cell(x: x, y: y, isBomb: false, count: 0),
      ),
    );
  }

  static List<List<int>> mines(int count, int rows, int columns) {
    final List<List<int>> list = [];

    while (list.length != count) {
      final x = _r.nextInt(columns - 1);
      final y = _r.nextInt(rows - 1);

      final location = [y, x];

      final exist =
          list.firstWhereOrNull((element) => listEquals(element, location));

      if (exist == null) {
        list.add(location);
      }
    }

    return [];
  }
}
