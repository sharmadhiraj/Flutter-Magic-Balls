import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/components/ball.dart';
import 'package:flutter_magic_balls/models/ball.dart';
import 'package:flutter_magic_balls/models/ball_future.dart';
import 'package:flutter_magic_balls/util/common.dart';
import 'package:flutter_magic_balls/util/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _borderColor = Config.containerBorderColor;
  final List<BallWidget> _balls = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _addNewBall());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildContainerBorder(),
        ..._balls,
      ],
    );
  }

  Widget _buildContainerBorder() {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top,
        bottom: MediaQuery.of(context).viewPadding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: _borderColor,
          style: BorderStyle.solid,
          width: Config.containerBorderWidth,
        ),
      ),
      duration: Config.containerGlowDuration,
      curve: Curves.easeInOut,
    );
  }

  void _handleBoundaryHit(Ball ball) {
    _handleBallFuture(ball);
    setState(() => _borderColor = ball.color);
    Future.delayed(
      Config.containerGlowDuration,
      () => setState(() => _borderColor = Config.containerBorderColor),
    );
  }

  void _handleBallFuture(Ball ball) {
    final BallFuture ballFuture = CommonUtil.getRandomFuture();
    if (ballFuture == BallFuture.create) {
      _addNewBall();
    } else if (ballFuture == BallFuture.vanish) {
      _removeBall(ball);
    }
  }

  void _addNewBall() {
    if (_balls.length > Config.maxBallsCount) return;
    setState(
      () => _balls.add(
        BallWidget(
          ball: Ball.create(),
          onHitBoundary: _handleBoundaryHit,
        ),
      ),
    );
  }

  void _removeBall(Ball ball) {
    if (_balls.length <= 1) return;
    setState(() =>
        _balls.removeWhere((ballWidget) => ballWidget.ball.id == ball.id));
  }
}
