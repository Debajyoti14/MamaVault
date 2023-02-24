import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/color_pallete.dart';

class PrimaryIconButton extends StatelessWidget {
  final Color backgroundColor;
  final String buttonTitle;
  final FaIcon buttonIcon;
  final double height;
  final void Function() onPressed;
  const PrimaryIconButton(
      {super.key,
      required this.buttonTitle,
      required this.buttonIcon,
      required this.onPressed,
      this.height = 60,
      this.backgroundColor = PalleteColor.primaryPurple});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: buttonIcon,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(buttonTitle),
        ),
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: backgroundColor,
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
