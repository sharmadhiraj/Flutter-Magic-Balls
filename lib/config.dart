import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/models/ball_fate.dart';

class Config {
  static const String appName = "Flutter Magic Balls";

  static const double ballRadius = 15;
  static const double ballSpeed = 200;
  static const int maxBalls = 20;

  static const double borderWidth = 8;
  static const double arenaMargin = 16;
  static const Color borderColor = Colors.white;
  static const double glowSeconds = 0.15;

  static const double maxStepSeconds = 1 / 30;

  static const Map<BallFate, int> fateWeights = {
    BallFate.vanish: 1,
    BallFate.create: 2,
    BallFate.nothing: 1,
  };

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
