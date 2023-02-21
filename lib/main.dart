import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interrupt/config/theme.dart';
import 'package:interrupt/provider/google_signin.dart';
import 'package:interrupt/screens/home_page.dart';
import 'package:interrupt/screens/onboarding/onboarding.dart';
import 'package:interrupt/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOnboarded = false;

  @override
  void initState() {
    _checkLoginPrefs();
    super.initState();
  }

  void _checkLoginPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        isOnboarded = prefs.getBool('isOnboarded') ?? false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
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
            nextScreen: isOnboarded ? const Home() : const OnboardingScreen()),
      ),
    );
  }
}
