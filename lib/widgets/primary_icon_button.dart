import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/color_pallete.dart';

class PrimaryIconButton extends StatelessWidget {
  final String buttonTitle;
  final FaIcon buttonIcon;
  const PrimaryIconButton(
      {super.key, required this.buttonTitle, required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: buttonIcon,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(buttonTitle),
        ),
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
      ),
    );
  }
}
