import 'package:flutter/material.dart';

import 'package:flutter_minesweeper/configs/AppDimensions.dart';

import 'package:flutter_minesweeper/Widgets/Screen/Screen.dart';
import 'Dimensions.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Screen(
      Dimensions.init,
      builder: (_) => Container(
        height: AppDimensions.size.height,
        child: Text("Game"),
      ),
    );
  }
}
