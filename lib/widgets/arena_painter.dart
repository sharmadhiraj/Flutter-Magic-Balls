import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/config.dart';
import 'package:flutter_magic_balls/models/ball.dart';
import 'package:flutter_magic_balls/arena/arena.dart';

class ArenaPainter extends CustomPainter {
  ArenaPainter(this.arena) : super(repaint: arena);

  final Arena arena;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Config.borderWidth
      ..color = arena.borderColor;
    canvas.drawCircle(
      arena.center,
      arena.radius - Config.borderWidth / 2,
      paint,
    );
    paint.style = PaintingStyle.fill;
    for (final Ball ball in arena.balls) {
      paint.color = ball.color;
      canvas.drawCircle(ball.position, Config.ballRadius, paint);
    }
  }

  @override
  bool shouldRepaint(ArenaPainter oldDelegate) => oldDelegate.arena != arena;
}
