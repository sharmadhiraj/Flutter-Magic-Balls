import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/models/ball_future.dart';

class Config {
  static const double ballSize = 30;
  static const Duration ballMovementDuration = Duration(milliseconds: 5);
  static const double containerBorderWidth = 8;
  static const Color containerBorderColor = Colors.white;
  static const Duration containerGlowDuration = Duration(milliseconds: 150);
  static const int maxBallsCount = 20;
  static const List<BallFuture> ballFuture = [
    BallFuture.vanish,
    BallFuture.create,
    BallFuture.create,
    BallFuture.nothing,
  ];
  static const List<Color> ballColors = [
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.white,
    Colors.green,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
    Colors.yellow,
  ];
}
