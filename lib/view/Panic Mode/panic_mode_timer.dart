import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/view_model/verified_number_provider.dart';
import 'package:interrupt/view/Panic%20Mode/panic_mode_message.dart';
import 'package:interrupt/view/Panic%20Mode/setup_panic.dart';
import 'package:interrupt/view/bottom_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../resources/colors.dart';

class PanicModeScreen extends StatefulWidget {
  const PanicModeScreen({super.key});

  @override
  State<PanicModeScreen> createState() => _PanicModeScreenState();
}

class _PanicModeScreenState extends State<PanicModeScreen> {
  final int _duration = 10;
  final CountDownController _countDownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    NumberProvider numberProvider = Provider.of(context, listen: false);
    final numbersAvailable = numberProvider.gerVerifiedNumber.length;
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
                textAlign: TextAlign.left,
              ),
            ),
            numbersAvailable > 0
                ? Column(
                    children: [
                      CircularCountDownTimer(
                        duration: _duration,
                        initialDuration: 0,
                        controller: _countDownController,
                        width: MediaQuery.of(context).size.width / 1.7,
                        height: MediaQuery.of(context).size.height / 1.7,
                        ringColor: AppColors.primaryPurple,
                        ringGradient: null,
                        fillColor: const Color.fromARGB(255, 209, 207, 255),
                        fillGradient: null,
                        backgroundColor:
                            const Color.fromARGB(255, 209, 207, 255),
                        backgroundGradient: null,
                        strokeWidth: 20.0,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                          fontSize: 33.0.sp,
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        autoStart: numbersAvailable > 0 ? true : false,
                        onStart: () {
                          debugPrint('Countdown Started');
                        },
                        onComplete: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const PanicModeMessageScreen(),
                            ),
                          );
                          debugPrint('Countdown Ended');
                        },
                        onChange: (String timeStamp) {
                          debugPrint('Countdown Changed $timeStamp');
                        },
                        timeFormatterFunction:
                            (defaultFormatterFunction, duration) {
                          if (duration.inSeconds == 0) {
                            return "Don't Panic";
                          } else {
                            return Function.apply(
                                defaultFormatterFunction, [duration]);
                          }
                        },
                      ),
                      SizedBox(
                        width: 153.w,
                        height: 60.h,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                  builder: (_) => const BottomNav()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: AppColors.bodyTextColorLight,
                            textStyle: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Lottie.network(
                          'https://assets3.lottiefiles.com/private_files/lf30_gtzclufw.json'),
                      SizedBox(height: 10.h),
                      Text(
                        'Add Phone No\'s to setup panic mode',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ).fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: (_) => const SetupPanicScreen()),
                          );
                        },
                        icon: const Icon(Icons.done, color: Colors.green),
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: const Text(
                            'Setup',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: AppColors.bodyTextColorLight,
                          textStyle: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
