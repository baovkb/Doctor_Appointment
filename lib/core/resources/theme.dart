import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    textTheme: _lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16,
        fontFamily: AppFonts.primaryFont,
      ),
      iconTheme: IconThemeData(color: AppColors.whiteColor)
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(
          fontFamily: AppFonts.primaryFont,
        )),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.whiteColor),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryColor)
      )
    ),
    colorScheme: ColorScheme.light(
      brightness:Brightness.light,
      primary: AppColors.primaryColor,
      error: AppColors.redColor,
      background: AppColors.whiteColor,
      surface: AppColors.whiteColor,
      onPrimary: AppColors.blackColor
    )
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.darkBg,
    textTheme: _darkTextTheme,
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          titleTextStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontFamily: AppFonts.primaryFont,
          ),
          iconTheme: IconThemeData(color: AppColors.primaryColor)
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary
      ),
      colorScheme: ColorScheme.dark(
          brightness:Brightness.dark,
          primary: AppColors.primaryColor,
          error: AppColors.redColor,
          background: AppColors.darkBg,
          surface: AppColors.darkBg,
          onPrimary: AppColors.darkWhite
      )
  );

  static final TextTheme _lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: 28,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold
    ),
    headlineMedium: TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: 24,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold
    ),
    headlineSmall: TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: 18,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold
    ),
    bodyLarge: TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: 16,
      color: AppColors.blackColor
    ),
    bodyMedium: TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: 14,
      color: AppColors.blackColor
    ),
    bodySmall: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 12,
        color: AppColors.blackColor
    )
  );

  static final _darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 28,
        color: AppColors.darkWhite,
        fontWeight: FontWeight.bold
    ),
    headlineMedium: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 24,
        color: AppColors.darkWhite,
        fontWeight: FontWeight.bold
    ),
    headlineSmall: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 18,
        color: AppColors.darkWhite,
        fontWeight: FontWeight.bold
    ),
    bodyLarge: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 16,
        color: AppColors.darkWhite,
        height: 1.6
    ),
    bodyMedium: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 14,
        color: AppColors.darkWhite,
        height: 1.4
    ),
    bodySmall: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: 12,
        color: AppColors.darkWhite
    )
  );
}