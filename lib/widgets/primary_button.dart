import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/color_pallete.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonTitle;
  final String? state;

  final void Function() onPressed;
  const PrimaryButton(
      {super.key,
      required this.buttonTitle,
      required this.onPressed,
      this.state = 'Initial'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: (state == 'Initial')
              ? PalleteColor.primaryPurple
              : (state == 'Processing')
                  ? const Color.fromARGB(255, 15, 244, 244)
                  : (state == 'Approved')
                      ? const Color.fromARGB(255, 6, 198, 35)
                      : const Color.fromARGB(255, 246, 96, 96),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(buttonTitle, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
