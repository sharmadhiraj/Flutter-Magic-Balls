import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/models/ball.dart';
import 'package:flutter_magic_balls/util/config.dart';

class BallWidget extends StatefulWidget {
  const BallWidget({
    required this.ball,
    required this.onHitBoundary,
    super.key,
  });

  final Ball ball;
  final void Function(Ball) onHitBoundary;

  @override
  State<BallWidget> createState() => _BallWidgetState();
}

class _BallWidgetState extends State<BallWidget> {
  Offset _circlePosition = const Offset(0, 0);
  late double _width, _height;
  double _statusBarHeight = 0;
  double _bottomBarHeight = 0;
  late Timer _timer;
  bool _movingRight = true;
  double _slope = 0;
  Color _color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _circlePosition.dx,
      top: _circlePosition.dy,
      child: Container(
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
        height: Config.ballSize,
        width: Config.ballSize,
      ),
    );
  }

  void _init() {
    _statusBarHeight = MediaQuery.of(context).viewPadding.top;
    _bottomBarHeight = MediaQuery.of(context).viewPadding.bottom;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _circlePosition = Offset(
      (_width - Config.ballSize) / 2,
      (_height - Config.ballSize) / 2,
    );
    _color = widget.ball.color;
    _initMovementDirection();
  }

  void _initMovementDirection() {
    final double initX = Random().nextDouble() * _width;
    final double initY = Random().nextDouble() * _height;
    _slope = (-initY + _circlePosition.dy) / (initX - _circlePosition.dx);
    _movingRight = initX > _circlePosition.dx;
    _initTimer();
  }

  void _initTimer() {
    _timer = Timer.periodic(
      Config.ballMovementDuration,
      (timer) {
        final double xDistance = sqrt(1 / (1 + pow(_slope, 2)));
        setState(
          () => _circlePosition = Offset(
            _circlePosition.dx + (_movingRight ? 1 : -1) * xDistance,
            _circlePosition.dy + (_movingRight ? -1 : 1) * _slope * xDistance,
          ),
        );
        if (_hitTopOrBottomBoundary()) {
          widget.onHitBoundary(widget.ball);
          setState(() => _slope = _slope * -1);
        }
        if (_hitLeftOrRightBoundary()) {
          widget.onHitBoundary(widget.ball);
          setState(() {
            _slope = _slope * -1;
            _movingRight = !_movingRight;
          });
        }
      },
    );
  }

  bool _hitTopOrBottomBoundary() {
    return _circlePosition.dy <
            Config.containerBorderWidth + _statusBarHeight ||
        _circlePosition.dy >
            _height -
                Config.ballSize -
                Config.containerBorderWidth -
                _bottomBarHeight;
  }

  bool _hitLeftOrRightBoundary() {
    return _circlePosition.dx >
            _width - Config.ballSize - Config.containerBorderWidth ||
        _circlePosition.dx < Config.containerBorderWidth;
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
