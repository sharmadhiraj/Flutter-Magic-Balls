import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/models/ball_future.dart';
import 'package:flutter_magic_balls/util/config.dart';

class CommonUtil {
  static String generateRandomId() {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String randomPart =
        Random().nextInt(999999).toString().padLeft(6, '0');
    return "$timestamp$randomPart";
  }

  static Color getRandomColor() {
    if (Config.ballColors.isEmpty) return Colors.teal;
    return Config.ballColors[Random().nextInt(Config.ballColors.length)];
  }

  static BallFuture getRandomFuture() {
    if (Config.ballFuture.isEmpty) return BallFuture.nothing;
    return Config.ballFuture[Random().nextInt(Config.ballFuture.length)];
  }
}
