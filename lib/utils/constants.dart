import 'package:flutter/material.dart';

double sizeh(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double sizew(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class AppTheme {
  static bool isDarkMode = true;

  static Color get primaryColor => isDarkMode
      ? const Color(0xff0a1625)
      : const Color(0xffecfefe); //night or day
  static Color get secondaryColor => isDarkMode
      ? const Color(0xffecfefe)
      : const Color(0xff0a1625); //day or night
  static Color get textColor => isDarkMode ? Colors.black : Colors.white;
  static Color get iconColor =>
      isDarkMode ? const Color(0xff2f6cae) : Colors.white;

  static TextStyle get headingTextStyle => const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w100,
        color: Colors.blue,
      );

  static TextStyle get titleTextStyle => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: secondaryColor,
      );

  static TextStyle get defaultTextStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      );

  static TextStyle get subtitleTextStyle => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w100,
        color: Colors.white,
      );

  static TextStyle get subtitle2TextStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      );
}
