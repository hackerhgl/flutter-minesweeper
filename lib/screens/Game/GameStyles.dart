import 'package:flutter/material.dart';

import 'package:flutter_minesweeper/configs/AppDimensions.dart';
import 'package:pigment/pigment.dart';

abstract class GameStyles {
  static final colorMap = {
    0: Colors.transparent,
    1: Pigment.fromString("#0400fb"),
    2: Pigment.fromString("#047e03"),
    3: Pigment.fromString("#fe0000"),
    4: Pigment.fromString("#020086"),
    5: Pigment.fromString("#7c0403"),
    6: Pigment.fromString("#10797a"),
    7: Pigment.fromString("#000000"),
    8: Pigment.fromString("#808080"),
  };

  static Widget infoBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.padding * 1,
        horizontal: AppDimensions.padding * 1,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        // borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15 + AppDimensions.ratio * 8,
          color: colorMap[3],
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  static Widget noOfNeighbours(int no, double boxSize) {
    return Text(
      no > 0 ? "$no" : "",
      style: TextStyle(
        color: colorMap[no],
        fontSize: boxSize * 0.65,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
