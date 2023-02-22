import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/color_pallete.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonTitle;

  final void Function() onPressed;
  const PrimaryButton(
      {super.key, required this.buttonTitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: PalleteColor.primaryPurple,
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(buttonTitle),
        ),
      ),
    );
  }
}
