import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/colors.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: AppColors.bodyTextColorLight,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(foregroundColor: Colors.white),
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  scaffoldBackgroundColor: const Color.fromARGB(255, 14, 14, 23),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundDark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 14, 14, 23),
    elevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.backgroundDark,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(foregroundColor: Colors.white),
);
