import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/Mixins/HoverWidget.dart';

import 'dart:math' as Math;

import 'package:flutter_minesweeper/configs/AppDimensions.dart';
import 'package:simple_animations/simple_animations/animation_controller_x/animation_controller_mixin.dart';

// class Smiley extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final size = 60.0;
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(size / 2),
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(size / 2),
//           gradient: LinearGradient(
//             colors: [
//               Colors.orange,
//               Colors.yellow,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: size * 0.2,
//               left: 10,
//               right: 10,
//               child: Row(
//                 children: [
//                   this.buildEye(size),
//                   Expanded(child: Container()),
//                   this.buildEye(size),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: size * 0.1,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   child: CustomPaint(
//                     painter: MouthPainter(),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildEye(double baseSize) {
//     final size = baseSize * 0.3;
//     final lenseSize = size * 0.45;
//     return Container(
//       height: size,
//       width: size * 0.77,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.elliptical(25, 36.0),
//         ),
//         border: Border.all(width: 1.2),
//       ),
//       child: Container(
//         width: lenseSize,
//         height: lenseSize,
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(lenseSize / 2),
//         ),
//       ),
//     );
//   }
// }

class Smiley extends StatefulWidget {
  Smiley({this.onHold, this.exploded});
  final bool onHold;
  final bool exploded;
  final Duration duration = Duration(milliseconds: 180);

  @override
  _SmileyState createState() => _SmileyState();
}

class _SmileyState extends State<Smiley> with AnimationControllerMixin {
  Animation<double> animation;

  @override
  void initState() {
    animation = Tween(begin: -0.4, end: 0.4).animate(controller);
    controller.addTask(SetValueTask(value: 1.0));
    super.initState();
  }

  @override
  void didUpdateWidget(Smiley oldWidget) {
    // print("Explode::: old : ${oldWidget.exploded} new:${widget.exploded}");
    // print("onHold::: old : ${oldWidget.onHold} new:${widget.onHold}");
    // if (!oldWidget.onHold && widget.onHold) {
    //   print("POKER");
    //   animation = Tween(begin: animation.value, end: 0.0).animate(controller);
    //   controller.addTasks(
    //     [
    //       FromToTask(duration: widget.duration, to: 1.0),
    //     ],
    //   );
    // } else if (oldWidget.onHold && !widget.onHold) {
    //   print("HAPPY");
    //   animation = Tween(begin: 0.4, end: animation.value).animate(controller);
    //   controller.addTasks(
    //     [
    //       FromToTask(duration: widget.duration, to: 0.0),
    //     ],
    //   );
    // } else if (oldWidget.onHold && !widget.onHold && widget.exploded) {
    //   animation = Tween(begin: animation.value, end: -0.3).animate(controller);
    //   controller.addTasks(
    //     [
    //       FromToTask(duration: widget.duration, to: 1.0),
    //     ],
    //   );
    // }

    if (widget.onHold && !widget.exploded) {
      controller.addTask(FromToTask(duration: widget.duration, to: 0.5));
    } else if ((!widget.onHold && !widget.exploded) ||
        (oldWidget.exploded && !widget.exploded)) {
      controller.addTask(FromToTask(duration: widget.duration, to: 1.0));
    } else if (widget.exploded) {
      controller.addTask(FromToTask(duration: widget.duration, to: 0.0));
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.ratio * 35;
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SmileyPainter(this.animation.value),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter(this.simleyCurve);
  final double simleyCurve;
  @override
  void paint(Canvas canvas, Size size) {
    final radius = Math.min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = size.width * 0.03;

    // Draw the body border
    final gradient = LinearGradient(
      colors: [
        Colors.red[400],
        Colors.yellow,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = gradient.createShader(Rect.fromCircle(
          center: center,
          radius: radius,
        ))
        ..style = PaintingStyle.fill,
    );

    // Draw body color
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke * 1.2,
    );

    // Draw the eyes
    final eyePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 1.4;
    final eyeRadius = radius * 0.18;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.38, center.dy - radius * 0.34),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.38, center.dy - radius * 0.34),
      eyeRadius,
      eyePaint,
    );

    // Draw Smile
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 2;
    var path = Path();
    final offset = Offset(
      size.width * 0.20,
      size.height * 0.65,
    );
    path.moveTo(offset.dx, offset.dy);
    path.quadraticBezierTo(
      size.width / 2,
      offset.dy * (1 + this.simleyCurve),
      size.width - offset.dx,
      offset.dy,
    );

    canvas.drawPath(path, smilePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
