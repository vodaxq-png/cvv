import 'package:flutter/material.dart';
import 'radar_screen.dart';

void main() {
  runApp(const SmartRadarApp());
}

class SmartRadarApp extends StatelessWidget {
  const SmartRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RadarScreen(),
    );
  }
}
