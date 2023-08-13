import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interrupt/model/user_model.dart';
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
    final res = await checkUserOnboarded();
    await prefs.setBool('isOnboarded', res ?? false);
    setState(
      () {
        isOnboarded = res ?? false;
      },
    );
  }

  Future<bool?> checkUserOnboarded() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User currentUser = auth.currentUser!;
    try {
      DocumentReference docRef =
          firestore.collection('users').doc(currentUser.uid);
      DocumentSnapshot docData = await docRef.get();

      final userData =
          UserModel.fromJson(docData.data() as Map<String, dynamic>);
      if (userData.bloodGroup == "" ||
          userData.allergies.isEmpty ||
          userData.medicines.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
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
              height: 150.h,
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
