import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Logo placeholder
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9FA8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Scheme Spark',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102A5C),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your Guide to Government Schemes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF607D8B),
                ),
              ),

              const SizedBox(height: 45),

              const Text(
                'Empowering People',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF78909C),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Building a Better Tomorrow',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF78909C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}