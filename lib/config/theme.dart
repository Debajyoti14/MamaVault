import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_pallete.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryPurple,
  backgroundColor: backgroundDark,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
);
