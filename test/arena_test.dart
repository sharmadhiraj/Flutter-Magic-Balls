import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:flutter_magic_balls/arena/arena.dart';
import 'package:flutter_magic_balls/config.dart';
import 'package:flutter_magic_balls/models/ball.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Arena arena;
  late double limit;

  setUp(() {
    arena = Arena(random: Random(1))..resize(const Size(400, 400));
    limit = arena.radius - Config.borderWidth / 2 - Config.ballRadius;
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

  test("a ball hitting the wall is reflected and duplicated", () {
    int hits = 0;
    final Arena observed = Arena(onWallHit: () => hits++, random: Random(1))
      ..resize(const Size(400, 400));
    final Ball ball = ballAt(
      observed.center + Offset(limit - 1, 0),
      const Offset(Config.ballSpeed, 0),
    );
    observed.balls.add(ball);
    observed.step(0.1);
    expect(ball.velocity.dx, lessThan(0));
    expect(observed.balls, hasLength(2));
    expect(hits, 1);
  });

  test("every wall hit duplicates until the maximum ball count", () {
    arena.reset();
    for (int i = 0; i < 20000; i++) {
      arena.step(1 / 60);
      expect(arena.balls.length, lessThanOrEqualTo(Config.maxBalls));
      for (final Ball ball in arena.balls) {
        expect(
          (ball.position - arena.center).distance,
          lessThanOrEqualTo(limit + 1e-6),
        );
      }
    }
  });

  test("a duplicate gets a different color than its parent", () {
    final Ball ball = ballAt(
      arena.center + Offset(limit - 1, 0),
      const Offset(Config.ballSpeed, 0),
    );
    arena.balls.add(ball);
    arena.step(0.1);
    expect(arena.balls.last.color, isNot(ball.color));
  });

  test("a duplicate does not vanish with its parent", () {
    final Ball ball = ballAt(
      arena.center + Offset(limit - 1, 0),
      const Offset(Config.ballSpeed, 0),
    );
    arena.balls.add(ball);
    arena.step(0.1);
    for (int i = 0; i < 30; i++) {
      arena.step(1 / 60);
    }
    expect(arena.balls.length, greaterThanOrEqualTo(2));
  });

  test("two balls that touch both vanish and a new one starts at center", () {
    arena.balls.addAll([
      ballAt(arena.center - const Offset(5, 0), Offset.zero),
      ballAt(arena.center + const Offset(5, 0), Offset.zero),
    ]);
    arena.step(0.001);
    expect(arena.balls, hasLength(1));
    expect(arena.balls.single.position, arena.center);
  });

  test("balls that do not touch are kept", () {
    arena.balls.addAll([
      ballAt(arena.center - const Offset(50, 0), Offset.zero),
      ballAt(arena.center + const Offset(50, 0), Offset.zero),
    ]);
    arena.step(0.001);
    expect(arena.balls, hasLength(2));
  });
}
