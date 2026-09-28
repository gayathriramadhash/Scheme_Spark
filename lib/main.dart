import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SchemeSparkApp());
}

class SchemeSparkApp extends StatelessWidget {
  const SchemeSparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scheme Spark',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}