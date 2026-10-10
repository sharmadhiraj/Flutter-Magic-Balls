import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_magic_balls/config.dart';
import 'package:flutter_magic_balls/models/ball.dart';
import 'package:flutter_magic_balls/models/ball_fate.dart';
import 'package:flutter_magic_balls/arena/offset_math.dart';

class Arena extends ChangeNotifier {
  Arena({this.onWallHit, Random? random}) : _random = random ?? Random();

  final VoidCallback? onWallHit;
  final Random _random;
  final List<Ball> balls = [];

  Offset center = Offset.zero;
  double radius = 0;

  Color _glowColor = Config.borderColor;
  double _glowRemaining = 0;

  Color get borderColor => Color.lerp(
    Config.borderColor,
    _glowColor,
    _glowRemaining / Config.glowSeconds,
  )!;

  double get _maxCenterDistance =>
      radius - Config.borderWidth / 2 - Config.ballRadius;

  void resize(Size size) {
    center = size.center(Offset.zero);
    radius = size.shortestSide / 2 - Config.arenaMargin;
  }

  void reset() {
    balls.clear();
    _glowRemaining = 0;
    spawn(center);
  }

  void spawn(Offset position) {
    final bool isOutside = (position - center).distance > _maxCenterDistance;
    if (isOutside || balls.length >= Config.maxBalls) return;
    balls.add(
      Ball(
        color: Config.ballColors[_random.nextInt(Config.ballColors.length)],
        position: position,
        velocity: Offset.fromDirection(
          _random.nextDouble() * 2 * pi,
          Config.ballSpeed,
        ),
      ),
    );
    notifyListeners();
  }

  void step(double seconds) {
    for (final Ball ball in balls) {
      ball.position += ball.velocity * seconds;
    }
    final List<Ball> hits = balls.where(_bounceOffWall).toList();
    _collideBalls();
    hits.forEach(_handleWallHit);
    _glowRemaining = max(0, _glowRemaining - seconds);
    notifyListeners();
  }

  bool _bounceOffWall(Ball ball) {
    final Offset offset = ball.position - center;
    if (offset.distance <= _maxCenterDistance) return false;
    final Offset normal = offset / offset.distance;
    ball.position = center + normal * _maxCenterDistance;
    if (ball.velocity.dot(normal) <= 0) return false;
    ball.velocity = ball.velocity.reflect(normal);
    return true;
  }

  void _collideBalls() {
    for (int i = 0; i < balls.length; i++) {
      for (int j = i + 1; j < balls.length; j++) {
        _collide(balls[i], balls[j]);
      }
    }
  }

  void _collide(Ball a, Ball b) {
    final Offset delta = b.position - a.position;
    final double distance = delta.distance;
    if (distance == 0 || distance >= Config.ballRadius * 2) return;
    final Offset normal = delta / distance;
    final Offset separation = normal * (Config.ballRadius - distance / 2);
    a.position -= separation;
    b.position += separation;
    if (a.velocity.dot(normal) > 0) a.velocity = a.velocity.reflect(normal);
    if (b.velocity.dot(normal) < 0) b.velocity = b.velocity.reflect(normal);
  }

  void _handleWallHit(Ball ball) {
    _glowColor = ball.color;
    _glowRemaining = Config.glowSeconds;
    onWallHit?.call();
    switch (_randomFate()) {
      case BallFate.create:
        spawn(ball.position);
      case BallFate.vanish:
        if (balls.length > 1) balls.remove(ball);
      case BallFate.nothing:
        break;
    }
  }

  BallFate _randomFate() {
    int roll = _random.nextInt(
      Config.fateWeights.values.fold(0, (int sum, int weight) => sum + weight),
    );
    for (final MapEntry<BallFate, int> entry in Config.fateWeights.entries) {
      roll -= entry.value;
      if (roll < 0) return entry.key;
    }
    return BallFate.nothing;
  }
}
