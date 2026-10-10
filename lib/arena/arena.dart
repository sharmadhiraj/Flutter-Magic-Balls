import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_magic_balls/arena/offset_math.dart';
import 'package:flutter_magic_balls/config.dart';
import 'package:flutter_magic_balls/models/ball.dart';

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
    _addCenterBall();
    notifyListeners();
  }

  void step(double seconds) {
    for (final Ball ball in balls) {
      ball.position += ball.velocity * seconds;
    }
    _removeCollidingBalls();
    balls.where(_bounceOffWall).toList().forEach(_duplicate);
    if (balls.isEmpty) _addCenterBall();
    _glowRemaining = max(0, _glowRemaining - seconds);
    notifyListeners();
  }

  void _addCenterBall() {
    _addBall(
      Ball(
        color: _randomColor(),
        position: center,
        velocity: Offset.fromDirection(
          _random.nextDouble() * 2 * pi,
          Config.ballSpeed,
        ),
      ),
    );
  }

  void _addBall(Ball ball) {
    if (balls.length < Config.maxBalls) balls.add(ball);
  }

  void _removeCollidingBalls() {
    final Set<Ball> colliding = {};
    for (int i = 0; i < balls.length; i++) {
      for (int j = i + 1; j < balls.length; j++) {
        final Ball a = balls[i];
        final Ball b = balls[j];
        if ((a.position - b.position).distance >= Config.ballRadius * 2) {
          if (a.twin == b) a.twin = b.twin = null;
        } else if (a.twin != b) {
          colliding.addAll([a, b]);
        }
      }
    }
    balls.removeWhere(colliding.contains);
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

  void _duplicate(Ball ball) {
    _glowColor = ball.color;
    _glowRemaining = Config.glowSeconds;
    onWallHit?.call();
    final Offset inward = (center - ball.position) / _maxCenterDistance;
    final Offset tangent = Offset(inward.dy, -inward.dx);
    final double side = ball.velocity.dot(tangent) < 0 ? -1 : 1;
    final double spread = 0.25 + _random.nextDouble() * 0.8;
    final Ball twin = Ball(
      color: _randomColor(except: ball.color),
      position: ball.position,
      velocity: Offset.fromDirection(
        inward.direction + side * spread,
        Config.ballSpeed,
      ),
    );
    if (balls.length >= Config.maxBalls) return;
    ball.twin = twin;
    twin.twin = ball;
    balls.add(twin);
  }

  Color _randomColor({Color? except}) {
    final List<Color> colors = Config.ballColors
        .where((color) => color != except)
        .toList();
    return colors[_random.nextInt(colors.length)];
  }
}
