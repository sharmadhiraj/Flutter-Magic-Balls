import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:flutter_magic_balls/arena/arena.dart';
import 'package:flutter_magic_balls/config.dart';
import 'package:flutter_magic_balls/models/ball.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Arena arena;

  setUp(() {
    arena = Arena(random: Random(1))..resize(const Size(400, 400));
  });

  Ball ballAt(Offset position, Offset velocity) {
    return Ball(
      color: const Color(0xFFFFFFFF),
      position: position,
      velocity: velocity,
    );
  }

  test("reset leaves exactly one ball at the center", () {
    arena
      ..reset()
      ..reset();
    expect(arena.balls, hasLength(1));
    expect(arena.balls.single.position, arena.center);
  });

  test("spawn ignores positions outside the arena", () {
    arena.spawn(Offset.zero);
    expect(arena.balls, isEmpty);
  });

  test("spawn stops at the maximum ball count", () {
    for (int i = 0; i < Config.maxBalls + 5; i++) {
      arena.spawn(arena.center);
    }
    expect(arena.balls, hasLength(Config.maxBalls));
  });

  test("a ball stays inside the arena after hitting the wall", () {
    arena.balls.add(ballAt(arena.center, const Offset(Config.ballSpeed, 0)));
    for (int i = 0; i < 300; i++) {
      arena.step(Config.maxStepSeconds);
    }
    for (final Ball ball in arena.balls) {
      expect(
        (ball.position - arena.center).distance,
        lessThanOrEqualTo(
          arena.radius - Config.borderWidth / 2 - Config.ballRadius + 1e-6,
        ),
      );
    }
  });

  test("a ball moving into the wall is reflected and reports the hit", () {
    int hits = 0;
    final Arena observed = Arena(onWallHit: () => hits++, random: Random(1))
      ..resize(const Size(400, 400));
    final double limit =
        observed.radius - Config.borderWidth / 2 - Config.ballRadius;
    final Ball ball = ballAt(
      observed.center + Offset(limit - 1, 0),
      const Offset(Config.ballSpeed, 0),
    );
    observed
      ..balls.add(ball)
      ..step(0.1);
    expect(ball.velocity.dx, lessThan(0));
    expect(hits, 1);
  });

  test("overlapping balls moving toward each other bounce apart", () {
    final Ball left = ballAt(
      arena.center - const Offset(Config.ballRadius - 1, 0),
      const Offset(Config.ballSpeed, 0),
    );
    final Ball right = ballAt(
      arena.center + const Offset(Config.ballRadius - 1, 0),
      const Offset(-Config.ballSpeed, 0),
    );
    arena
      ..balls.addAll([left, right])
      ..step(0.001);
    expect(left.velocity.dx, lessThan(0));
    expect(right.velocity.dx, greaterThan(0));
  });
}
