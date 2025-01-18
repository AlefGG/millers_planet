import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class UIThemes {
  final Brightness brightness;

  UIThemes({this.brightness = Brightness.light});

  // Основная тема приложения (светлая)
  static ThemeData lightTheme() => ThemeData(
        // useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: "SF Pro Display",
        scaffoldBackgroundColor: LightModeColors.backgroundPrimary,
        dividerColor: Colors.transparent,
        dialogTheme: const DialogTheme(
          elevation: 0,
          backgroundColor: LightModeColors.mainColorsWhite,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          centerTitle: true,
          backgroundColor: LightModeColors.backgroundSecondary,
          elevation: 0,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
        ),
        colorScheme: const ColorScheme.light(
          primary: LightModeColors.backgroundPrimary,
          onSecondary: LightModeColors.backgroundSecondary,
        ),
        textTheme: const TextTheme(),
      );

  // Альтернативная тема приложения (тёмная)
  static ThemeData darkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DarkModeColors.backgroundPrimary,
        dividerColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
          ),
          centerTitle: true,
          backgroundColor: DarkModeColors.backgroundSecondary,
          elevation: 0,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
        ),
        colorScheme: const ColorScheme.dark(
          primary: DarkModeColors.mainColorsWhite,
          onSecondary: DarkModeColors.backgroundSecondary,
        ),
      );

  static UIThemes of(BuildContext context) {
    return UIThemes(brightness: Theme.of(context).brightness);
  }

  bool get isDarkTheme => brightness == Brightness.dark;

  TextStyle get largeTitle64 => TextStyle(
        fontSize: 64,
        fontFamily: 'IBMPlexSans',
        color: textPrimary,
        fontWeight: FontWeight.bold,
        height: 64 / 64,
      );

  TextStyle get largeTitle48 => TextStyle(
        fontSize: 48,
        fontFamily: 'IBMPlexSans',
        color: textPrimary,
        fontWeight: FontWeight.bold,
        height: 64 / 64,
      );

  TextStyle get largeTitleThin64 => TextStyle(
        fontSize: 64,
        fontFamily: 'IBMPlexSans',
        color: textPrimary,
        fontWeight: FontWeight.w100,
        height: 64 / 64,
      );

  TextStyle get text24Regular => TextStyle(
        fontSize: 24,
        fontFamily: 'IBMPlexSans',
        color: textPrimary,
        fontWeight: FontWeight.normal,
        height: 24 / 24,
      );

  TextStyle get text24Bold => TextStyle(
        fontSize: 24,
        fontFamily: 'IBMPlexSans',
        color: textPrimary,
        fontWeight: FontWeight.bold,
        height: 24 / 24,
      );

  TextStyle get text24Thin => TextStyle(
        fontSize: 24,
        fontFamily: 'IBMPlexSans',
        color: textPrimary,
        fontWeight: FontWeight.w100,
        height: 24 / 24,
      );

  Color get textPrimary =>
      isDarkTheme ? DarkModeColors.textPrimary : LightModeColors.textPrimary;

  Color get greyPrimary =>
      isDarkTheme ? DarkModeColors.greyPrimary : LightModeColors.greyPrimary;

  Color get greySecondary => isDarkTheme
      ? DarkModeColors.greySecondary
      : LightModeColors.greySecondary;
}
