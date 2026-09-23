import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2196F3);
  static const background = Color(0xFFFAFAFA);
  static const buttonBackground = Color(0xFF6EC6FA);
  static const buttonBorder = Color(0xFF448AFF);
  static const buttonForeground = Colors.black87;
  static const icon = Colors.black45;
  static const hint = Colors.black38;
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shadowColor: Colors.black54,
      centerTitle: false,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.buttonBackground,
        foregroundColor: AppColors.buttonForeground,
        disabledBackgroundColor: AppColors.buttonBackground.withValues(alpha: 0.6),
        disabledForegroundColor: AppColors.buttonForeground,
        side: const BorderSide(color: AppColors.buttonBorder, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.hint),
    ),
    iconTheme: const IconThemeData(color: AppColors.icon),
  );
}
