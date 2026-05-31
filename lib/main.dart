import 'package:flutter/material.dart';
import 'screens/pin_screen.dart';

void main() {
  runApp(const MoneyTrackerApp());
}

class MoneyTrackerApp extends StatelessWidget {
  const MoneyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEAF7FF),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PinScreen(),
    );
  }
}