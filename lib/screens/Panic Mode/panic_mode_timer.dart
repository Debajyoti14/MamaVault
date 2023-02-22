import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:interrupt/screens/Panic%20Mode/panic_mode_message.dart';
import 'package:interrupt/screens/bottom_nav_bar.dart';

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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Panic Mode',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            CircularCountDownTimer(
              duration: _duration,
              initialDuration: 0,
              controller: _countDownController,
              width: MediaQuery.of(context).size.width / 1.7,
              height: MediaQuery.of(context).size.height / 1.7,
              ringColor: PalleteColor.primaryPurple,
              ringGradient: null,
              fillColor: const Color.fromARGB(255, 209, 207, 255),
              fillGradient: null,
              backgroundColor: const Color.fromARGB(255, 209, 207, 255),
              backgroundGradient: null,
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                  fontSize: 33.0,
                  color: PalleteColor.primaryPurple,
                  fontWeight: FontWeight.bold),
              textFormat: CountdownTextFormat.S,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: true,
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
              timeFormatterFunction: (defaultFormatterFunction, duration) {
                if (duration.inSeconds == 0) {
                  return "Don't Panic";
                } else {
                  return Function.apply(defaultFormatterFunction, [duration]);
                }
              },
            ),
            SizedBox(
              width: 153,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (_) => const BottomNav()),
                      (route) => false);
                },
                icon: const Icon(Icons.cancel, color: Colors.red),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: PalleteColor.bodyTextColorLight,
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
