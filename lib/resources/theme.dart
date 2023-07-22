import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/colors.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: AppColors.bodyTextColorLight,
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  scaffoldBackgroundColor: AppColors.backgroundDark,
);
