import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_pallete.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: PalleteColor.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: PalleteColor.bodyTextColorLight,
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: PalleteColor.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  scaffoldBackgroundColor: PalleteColor.backgroundDark,
);
