import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interrupt/repository/panic_repository.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view/Panic%20Mode/hospital_details.dart';

import 'package:lottie/lottie.dart';

class PanicModeMessageScreen extends StatefulWidget {
  const PanicModeMessageScreen({super.key});

  @override
  State<PanicModeMessageScreen> createState() => _PanicModeMessageScreenState();
}

class _PanicModeMessageScreenState extends State<PanicModeMessageScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  PanicRepository panicRepository = PanicRepository();
  @override
  void initState() {
    panicRepository.sendPanicRequest(name: user.displayName!, uid: user.uid);
    if (context.mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const HospitalDetails(),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Panic Mode',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50.h),
            Lottie.network(
              'https://assets7.lottiefiles.com/private_files/lf30_dfxejf4d.json',
              width: 300.w,
            ),
            SizedBox(height: 30.h),
            Text(
              'Sending Emergency Message',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
