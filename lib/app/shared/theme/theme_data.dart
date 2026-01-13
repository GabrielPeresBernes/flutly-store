import 'package:flutter/material.dart';

import 'tokens/color_tokens.dart';

final themeData = ThemeData(
  scaffoldBackgroundColor: AppColors.white,
  canvasColor: AppColors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 12,
    ),
    labelLarge: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Montserrat',
      color: AppColors.black,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      color: AppColors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Montserrat',
      color: AppColors.black,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 13,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.gray100,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.gray100,
      ),
    ),
    hintStyle: const TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.gray100,
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 14,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.gray400,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.black.withValues(alpha: 0.8),
      ),
    ),
    iconColor: AppColors.gray100,
    prefixIconColor: AppColors.gray100,
    prefixIconConstraints: const BoxConstraints.tightFor(height: 20),
    suffixIconColor: AppColors.gray100,
    suffixIconConstraints: const BoxConstraints.tightFor(height: 20),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 14,
    ),
    menuStyle: MenuStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      elevation: WidgetStateProperty.all(4),
      backgroundColor: WidgetStateProperty.all(AppColors.white),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      side: const BorderSide(color: AppColors.gray200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      foregroundColor: AppColors.black,
      disabledForegroundColor: AppColors.gray200,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shadowColor: AppColors.black.withValues(alpha: 0.1),
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      foregroundColor: AppColors.white,
    ),
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    shape: Border(),
    backgroundColor: AppColors.white,
    collapsedBackgroundColor: AppColors.white,
    tilePadding: EdgeInsets.zero,
    childrenPadding: EdgeInsets.symmetric(vertical: 10),
    iconColor: AppColors.black,
    collapsedIconColor: AppColors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      foregroundColor: AppColors.black,
      disabledForegroundColor: AppColors.gray200,
      textStyle: const TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.white,
    selectedColor: AppColors.primary,
    disabledColor: AppColors.gray300,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: AppColors.gray100),
    ),
    side: const BorderSide(color: AppColors.gray100),
    labelStyle: const TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 14,
    ),
    secondaryLabelStyle: const TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.white,
      fontSize: 14,
    ),
    labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    padding: EdgeInsets.zero,
    showCheckmark: false,
  ),
  badgeTheme: const BadgeThemeData(
    backgroundColor: AppColors.primary,
    textColor: AppColors.white,
    textStyle: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.white,
    contentTextStyle: const TextStyle(
      fontFamily: 'DM Sans',
      color: AppColors.black,
      fontSize: 14,
    ),
    elevation: 8,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    actionTextColor: AppColors.primary,
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    color: AppColors.gray400,
  ),
  splashColor: AppColors.gray200.withValues(alpha: 0.5),
  highlightColor: AppColors.gray200.withValues(alpha: 0.4),
);
