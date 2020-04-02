import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_minesweeper/configs/AppDimensions.dart';

import 'package:flutter_minesweeper/Widgets/Screen/Screen.dart';
import 'Dimensions.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class Cell {
  final int x;
  final int y;
  bool isBomb = false;
  int neighbours = 0;

  Cell({this.x, this.y});
}

final columns = 8;
final rows = 4;
final difficulty = 6;
final List<List<int>> neighbours = [
  [-1, 0],
  [-1, 1],
  [0, 1],
  [1, 1],
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
];

bool isValidPosition(x, y) {
  if (x < 0 || y < 0 || x >= rows || y >= columns) {
    return false;
  }
  return true;
}

generateGirid() {
  var grid = List.generate(
    columns,
    (yIndex) => List.generate(
      rows,
      (xIndex) => Cell(
        x: xIndex,
        y: yIndex,
      ),
    ),
  );

  // Generate bombs
  final List<String> bombs = [];
  final rand = math.Random();

  while (bombs.length < difficulty) {
    final test = "${rand.nextInt(columns)}-${rand.nextInt(rows)}";

    if (bombs.contains(test)) {
      continue;
    }

    bombs.add(test);
  }

  // Add generated bombs & no of neighbour bombs in grid

  bombs.forEach((String element) {
    final position = element.split("-").map((e) => int.parse(e)).toList();
    final yIndex = position[0];
    final xIndex = position[1];
    grid[yIndex][xIndex].isBomb = true;

    neighbours.forEach((neighbour) {
      final y = yIndex + neighbour[0];
      final x = xIndex + neighbour[1];

      if (!isValidPosition(x, y)) {
        return;
      }
      if (bombs.contains("$y-$x")) {
        return;
      }
      grid[y][x].neighbours++;
    });
  });

  return grid;
}

class _GameScreenState extends State<GameScreen> {
  List<List<Cell>> grid;

  @override
  void initState() {
    super.initState();

    this.grid = generateGirid();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      Dimensions.init,
      builder: (_) => Container(
        height: AppDimensions.size.height,
        child: Column(
          children: this
              .grid
              .map(
                (rows) => Row(
                  children: rows
                      .map(
                        (Cell cell) => this.buildCell(cell),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget buildCell(Cell cell) {
    final size = 80.0;
    return Container(
      width: size,
      height: size,
      color: cell.isBomb ? Colors.red : Colors.transparent,
      child: Center(
        child: Text(
          "${cell.neighbours}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
