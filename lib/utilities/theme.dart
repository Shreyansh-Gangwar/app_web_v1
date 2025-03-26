import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    primaryColor: AppColor.brand500,
    fontFamily: GoogleFonts.josefinSans().fontFamily,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: AppColor.neutral900,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColor.neutral900,
      ),
      labelMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColor.brand500,
      ),
    ),
  );
}
