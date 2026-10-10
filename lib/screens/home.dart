import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_magic_balls/config.dart';
import 'package:flutter_magic_balls/arena/arena.dart';
import 'package:flutter_magic_balls/widgets/arena_painter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final Arena _arena = Arena(onWallHit: HapticFeedback.selectionClick);
  late final Ticker _ticker = createTicker(_onTick);
  Duration _lastElapsed = Duration.zero;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _ticker.start();
    WidgetsBinding.instance.addPostFrameCallback((_) => _arena.reset());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _arena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildArena()),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildArena() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _arena.resize(constraints.biggest);
        return CustomPaint(size: Size.infinite, painter: ArenaPainter(_arena));
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: _paused ? "Resume" : "Pause",
          color: Config.borderColor,
          icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
          onPressed: () => setState(() => _paused = !_paused),
        ),
        IconButton(
          tooltip: "Reset",
          color: Config.borderColor,
          icon: const Icon(Icons.refresh),
          onPressed: _arena.reset,
        ),
      ],
    );
  }

  void _onTick(Duration elapsed) {
    final double seconds = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (!_paused) _arena.step(min(seconds, Config.maxStepSeconds));
  }
}
