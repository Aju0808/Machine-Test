import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_task/constants/color_constants.dart';

class AppTextStyle {
  static TextTheme lightTextTheme = TextTheme(
    titleLarge: GoogleFonts.poppins(
      color: ColorConstants.titleTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    titleMedium: GoogleFonts.poppins(
      color: ColorConstants.titleTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    titleSmall: GoogleFonts.poppins(
      color: ColorConstants.titleTextColor,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
  );
}
