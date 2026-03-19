import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGold = Color(0xFFF6BD00);
  static const Color background = Color(0xFF121312);
  static const Color cardGrey = Color(0xFF282A28);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.white54;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryGold,
      scaffoldBackgroundColor: AppColors.background,

   
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardGrey,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.textGrey,
      ),
    );
  }
}
