import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:interrupt/config/theme.dart';
import 'package:interrupt/screens/onoarding/onboarding.dart';
import 'package:interrupt/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MamaVault',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      home: AnimatedSplashScreen(
        backgroundColor: Colors.white,
        centered: true,
        duration: 2000,
        splashTransition: SplashTransition.fadeTransition,
        splash: const SplashScreen(),
        nextScreen: const Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}
