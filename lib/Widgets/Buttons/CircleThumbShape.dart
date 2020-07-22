import 'package:flutter/material.dart';

class CircleThumbShape extends SliderComponentShape {

  final double thumbRadius;
  final double innerThumbRadius;
  final Color mainColor;
  final Color innerColor;
  final Color borderColor;


  const CircleThumbShape({
    this.thumbRadius = 6.0,
    this.innerThumbRadius = 6.0,
    this.mainColor = Colors.white,
    this.innerColor  = Colors.white,
    this.borderColor = Colors.grey,

  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center, {Animation<double> activationAnimation, Animation<double> enableAnimation, bool isDiscrete, TextPainter labelPainter, RenderBox parentBox, SliderThemeData sliderTheme, TextDirection textDirection, double value}) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final innerPaint = Paint()
      ..color = innerColor
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
    canvas.drawCircle(center, innerThumbRadius, innerPaint);
  }


}