import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    useMaterial3: false,
    primarySwatch:
        MaterialColor(AppColor.brand500.toARGB32(), const <int, Color>{
          50: Color(0xFFFEF6F1),
          100: Color(0xFFFFEFE5),
          200: Color(0xFFFACAAF),
          300: Color(0xFFF7A87C),
          400: Color(0xFFF28649),
          500: Color(0xFFED691F),
          600: Color(0xFFB84B0F),
          700: Color(0xFF7D3107),
          800: Color(0xFF592203),
          900: Color(0xFF2D1000),
        }),
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
