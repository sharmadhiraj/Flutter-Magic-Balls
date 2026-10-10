import 'dart:ui';

class Ball {
  Ball({required this.color, required this.position, required this.velocity});

  final Color color;
  Offset position;
  Offset velocity;
  Ball? twin;
}
