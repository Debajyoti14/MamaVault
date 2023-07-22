import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view/home_page.dart';
import 'package:interrupt/view/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOnboarded = false;
  @override
  void initState() {
    super.initState();
    _checkLoginPrefs();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                isOnboarded ? const Home() : const OnboardingScreen(),
          ),
          (route) => false,
        );
      },
    );
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logoSvg.svg',
              height: 200.h,
            ),
            SizedBox(height: 30.h),
            Text(
              'MamaVault',
              style: TextStyle(color: AppColors.primaryPurple, fontSize: 26.sp),
            ),
          ],
        ),
      ),
    );
  }
}
