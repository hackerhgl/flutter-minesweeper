import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/configs/AppDimensions.dart';

abstract class AppText {
  static Text body1(String text, [TextStyle styles]) {
    return Text(
      text,
      style: (styles ?? TextStyle()).copyWith(
        fontSize: 8 + AppDimensions.ratio * 4,
      ),
    );
  }
}
