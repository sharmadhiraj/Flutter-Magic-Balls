import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/screens/home.dart';
import 'package:flutter_magic_balls/util/constants.dart';

void main() {
  runApp(const MagicBallsApp());
}

class MagicBallsApp extends StatelessWidget {
  const MagicBallsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constant.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
