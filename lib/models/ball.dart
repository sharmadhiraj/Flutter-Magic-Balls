import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/util/common.dart';

class Ball {
  final String id;
  final Color color;

  Ball({required this.id, required this.color});

  static Ball create() {
    return Ball(
      id: CommonUtil.generateRandomId(),
      color: CommonUtil.getRandomColor(),
    );
  }
}
