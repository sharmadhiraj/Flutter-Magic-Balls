import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/util/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset _circlePosition = const Offset(0, 0);
  late double _width, _height;
  double _statusBarHeight = 0;
  double _bottomBarHeight = 0;
  late Timer _timer;
  bool _movingRight = true;
  double _slope = 0;
  Color _borderColor = Config.containerBorderColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
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
        Positioned(
          left: _circlePosition.dx,
          top: _circlePosition.dy,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
            ),
            height: Config.ballSize,
            width: Config.ballSize,
          ),
        ),
      ],
    );
  }

  Widget _buildContainerBorder() {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        top: _statusBarHeight,
        bottom: _bottomBarHeight,
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

  void _init() {
    _statusBarHeight = MediaQuery.of(context).viewPadding.top;
    _bottomBarHeight = MediaQuery.of(context).viewPadding.bottom;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _circlePosition = Offset(
      (_width - Config.ballSize) / 2,
      (_height - Config.ballSize) / 2,
    );
    final double initX = Random().nextDouble() * _width;
    final double initY = _height;
    _slope = (-initY + _circlePosition.dy) / (initX - _circlePosition.dx);
    _movingRight = initX > _circlePosition.dx;
    _initTimer();
  }

  void _initTimer() {
    _timer = Timer.periodic(
      const Duration(milliseconds: Config.ballSpeed),
      (timer) {
        final double xDistance = sqrt(1 / (1 + pow(_slope, 2)));
        setState(
          () => _circlePosition = Offset(
            _circlePosition.dx + (_movingRight ? 1 : -1) * xDistance,
            _circlePosition.dy + (_movingRight ? -1 : 1) * _slope * xDistance,
          ),
        );
        if (_hitTopOrBottomBoundary()) {
          _glow();
          setState(() => _slope = _slope * -1);
        }
        if (_hitLeftOrRightBoundary()) {
          _glow();
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

  void _glow() {
    setState(() => _borderColor = Colors.pink);
    Future.delayed(
      Config.containerGlowDuration,
      () => setState(() => _borderColor = Config.containerBorderColor),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
