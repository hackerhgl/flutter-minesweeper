import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_minesweeper/Mixins/HoverWidget.dart';
import 'package:flutter_minesweeper/Widgets/EmbossedBox/EmbossedBox.dart';

import 'package:flutter_minesweeper/configs/AppDimensions.dart';

import 'package:flutter_minesweeper/Widgets/Screen/Screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'GameDimensions.dart';
import 'GameStyles.dart';
import 'Widgets/Smiley.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class Cell {
  final int x;
  final int y;
  bool isBomb = false;
  int neighbours = 0;
  bool isRevealed = false;
  bool didExplode = false;
  bool isOnHold = false;

  Cell({this.x, this.y});
}

final rows = 5;
final columns = 5;
final difficulty = 5;
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

bool isValidPosition({x, y}) {
  if (x < 0 || y < 0 || x >= columns || y >= rows) {
    return false;
  }
  return true;
}

generateGirid() {
  var grid = List.generate(
    rows,
    (yIndex) => List.generate(
      columns,
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
    final y = rand.nextInt(rows);
    final x = rand.nextInt(columns);
    final test = "$y-$x";

    if (bombs.contains(test)) {
      continue;
    }

    bombs.add(test);
  }

  // // Add generated bombs & no of neighbour bombs in grid
  bombs.forEach((String element) {
    final position = element.split("-").map((e) => int.parse(e)).toList();
    final yIndex = position[0];
    final xIndex = position[1];

    grid[yIndex][xIndex].isBomb = true;

    neighbours.forEach((neighbour) {
      final y = yIndex + neighbour[0];
      final x = xIndex + neighbour[1];

      // This check will skip if cell position is out of bound
      if (!isValidPosition(x: x, y: y)) {
        return;
      }
      // This check will skip if cell is a bomb
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
  bool isFinished = false;
  String gridKey;
  bool onHold = false;
  bool exploded = false;

  @override
  void initState() {
    super.initState();
    this.gridKey = getGridKey();
    this.grid = generateGirid();
  }

  String getGridKey() => DateTime.now().millisecondsSinceEpoch.toString();

  List getRevealedGrid() => this
      .grid
      .map(
        (row) => row.map(
          (element) {
            element.isRevealed = true;
            return element;
          },
        ).toList(),
      )
      .toList();

  void holdCell(Cell cell, bool flag) {
    if (this.isFinished) {
      return;
    }
    setState(() {
      this.onHold = flag;
      this.grid[cell.y][cell.x].isOnHold = flag;
    });
  }

  void revealCell(Cell cell) {
    if (this.isFinished) {
      return;
    }
    setState(() {
      this.onHold = false;
      if (cell.isBomb) {
        // Game Over
        this.grid = this.getRevealedGrid();

        this.grid[cell.y][cell.x].didExplode = true;
        this.isFinished = true;
        this.exploded = true;
      }
      this.grid[cell.y][cell.x].isRevealed = true;
    });
  }

  void restart() {
    setState(() {
      if (!this.isFinished) {
        this.isFinished = true;
        this.grid = this.getRevealedGrid();
      } else {
        this.isFinished = false;
        this.exploded = false;
        this.gridKey = this.getGridKey();
        this.grid = generateGirid();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      GameDimensions.init,
      builder: (_) => Center(
        child: Container(
          child: EmbossedBox(
            borderWidth: 3.0,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.padding),
              child: Column(
                children: <Widget>[
                  this.buildHeader(),
                  Container(height: AppDimensions.padding),
                  this.buildGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return DefaultTextStyle(
      style: TextStyle(fontFamily: "Digi"),
      child: EmbossedBox(
        inverse: true,
        borderWidth: 3.0,
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.padding * 1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GameStyles.infoBox("007"),
              Container(
                child: Icon(MaterialCommunityIcons.magnify_plus_outline),
              ),
              GestureDetector(
                onTap: () => this.restart(),
                child: Smiley(onHold: onHold, exploded: exploded),
              ),
              Container(
                child: Icon(Icons.add_alert),
              ),
              GameStyles.infoBox("00:79"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGrid() {
    return Container(
      width: double.infinity,
      key: Key(this.gridKey),
      child: EmbossedBox(
        borderWidth: 3.0,
        inverse: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 51.0 * columns,
            height: 51.0 * rows,
            child: ListView.builder(
              itemCount: rows,
              itemBuilder: (ctx, index) {
                return Row(
                  children: this
                      .grid[index]
                      .map(
                        (Cell cell) => this.buildCell(cell),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCell(Cell cell) {
    final size = 51.0;
    final duration = Duration(milliseconds: 220);
    final tween = MultiTrackTween(
      [
        Track("opacity")
            .add(duration, ConstantTween(1.0))
            .add(duration, Tween(begin: 1.0, end: 0.0)),
        Track("border").add(duration, Tween(begin: 5.0, end: 0.0)),
        Track("explodeColor").add(
            duration, ColorTween(begin: Colors.transparent, end: Colors.red))
      ],
    );
    return GestureDetector(
      onTap: () => this.revealCell(cell),
      onTapDown: (_) => this.holdCell(cell, true),
      onTapCancel: () => this.holdCell(cell, false),
      child: Container(
        width: size,
        height: size,
        child: ControlledAnimation(
          key: Key("${cell.y}-${cell.x}"),
          tween: tween,
          duration: tween.duration,
          playback:
              cell.isRevealed ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
          builder: (context, animation) {
            return ControlledAnimation(
              tween: Tween(begin: 5.0, end: 3.0),
              duration: tween.duration,
              playback:
                  cell.isOnHold ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
              builder: (context, holdAnimation) {
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color:
                            cell.didExplode ? animation["explodeColor"] : null,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ),
                      child: Center(
                        child: cell.isBomb
                            ? Text("LOLS")
                            : GameStyles.noOfNeighbours(cell.neighbours, size),
                      ),
                    ),
                    Opacity(
                      opacity: animation["opacity"],
                      child: EmbossedBox(
                        borderWidth: cell.isOnHold ||
                                (holdAnimation > 0 && !cell.isRevealed)
                            ? holdAnimation
                            : animation["border"],
                        child: Container(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
