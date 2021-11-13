import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app_with_provider/shared/components/constants.dart';
import 'package:notes_app_with_provider/shared/local/cache_helper.dart';

const Color bluishColor = Color(0xFF4e5ae8);
const Color orangeColor = Color(0xCFFF8746);
const Color pinkColor = Color(0xFFff4667);
const Color white = Colors.white;
const primaryColor = bluishColor;
const Color darkGreyColor = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);

class Themes with ChangeNotifier {
  //
  bool _isDarkModeBool = CacheHelper.getData(key: SharedPreferencesKeys.darkModeKey) ?? false;
  bool get isDarkModeBool => _isDarkModeBool;
  set isDarkModeBool(value) {
    _isDarkModeBool = value;
    CacheHelper.saveData(key: SharedPreferencesKeys.darkModeKey, value: value);
    notifyListeners();
  }

  static bool get isDarkMode => CacheHelper.getData(key: SharedPreferencesKeys.darkModeKey) ?? false;

  static get staticThemeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  static final lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
    appBarTheme: const AppBarTheme(backgroundColor: white),
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryVariant: primaryColor,
      secondary: pinkColor,
      secondaryVariant: pinkColor,
      surface: white,
      background: white,
      error: Colors.red,
      onPrimary: white,
      onSecondary: white,
      onSurface: darkGreyColor,
      onBackground: darkGreyColor,
      onError: white,
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: darkGreyColor,
    scaffoldBackgroundColor: darkGreyColor,
    appBarTheme: const AppBarTheme(backgroundColor: darkGreyColor),
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryVariant: primaryColor,
      secondary: pinkColor,
      secondaryVariant: pinkColor,
      surface: darkGreyColor,
      background: darkGreyColor,
      error: Colors.red,
      onPrimary: white,
      onSecondary: white,
      onSurface: white,
      onBackground: white,
      onError: white,
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,
  );
}

class TextStyles {
  //
  static TextStyle get headingStyle => GoogleFonts.lato(
        textStyle: TextStyle(
          color: Themes.isDarkMode ? white : Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
  static TextStyle get subHeadingStyle => GoogleFonts.lato(
        textStyle: TextStyle(
          color: Themes.isDarkMode ? white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
  static TextStyle get titleStyle => GoogleFonts.lato(
        textStyle: TextStyle(
          color: Themes.isDarkMode ? white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
  static TextStyle get subTitleStyle => GoogleFonts.lato(
        textStyle: TextStyle(
          color: Themes.isDarkMode ? white : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      );
  static TextStyle get bodyStyle => GoogleFonts.lato(
        textStyle: TextStyle(
          color: Themes.isDarkMode ? white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
  static TextStyle get body2Style => GoogleFonts.lato(
        textStyle: TextStyle(
          color: Themes.isDarkMode ? Colors.grey[200] : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
}
