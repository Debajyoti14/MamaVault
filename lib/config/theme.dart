import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_pallete.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: PalleteColor.primaryPurple,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  backgroundColor: PalleteColor.bodyTextColorLight,
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: PalleteColor.primaryPurple,
  backgroundColor: PalleteColor.backgroundDark,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
);
