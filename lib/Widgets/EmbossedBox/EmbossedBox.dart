import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class EmbossedBox extends StatelessWidget {
  EmbossedBox({
    @required this.child,
    this.inverse = false,
    this.borderWidth = 5.0,
    background,
  }) {
    this.background = background ?? Pigment.fromString("#bdbdbd");
  }

  final Widget child;
  final bool inverse;
  Color background;
  final double borderWidth;

  BorderSide getBorder([isWhite = false]) => BorderSide(
        color: isWhite ? Colors.white : Pigment.fromString("#7b7b7b"),
        width: this.borderWidth,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.background,
        border: Border(
          top: this.getBorder(!this.inverse),
          left: this.getBorder(!this.inverse),
          right: this.getBorder(this.inverse),
          bottom: this.getBorder(this.inverse),
        ),
      ),
      child: this.child,
    );
  }
}
