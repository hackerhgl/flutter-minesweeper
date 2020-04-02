import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/UI.dart';

import 'package:flutter_minesweeper/configs/AppDimensions.dart';

class Dimensions {
  static double buttonWidth;

  static init(BuildContext context) {
    AppDimensions.init(context);
    buttonWidth = double.infinity;

    if (UI.sm) {
      buttonWidth = 200;
    }
  }
}
