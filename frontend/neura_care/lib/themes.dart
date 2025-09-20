import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryVariant = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  
  // Medical/Health themed colors
  static const Color healthGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightOutline = Color(0xFFE0E0E0);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSurface = Color(0xFFE6E1E5);
  static const Color darkOutline = Color(0xFF424242);

  // Text Theme
  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.0,
    ),
    displaySmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
    ),
    headlineLarge: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
    ),
    headlineMedium: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    titleSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: Color(0xFFE3F2FD),
        secondary: secondaryColor,
        secondaryContainer: Color(0xFFE0F2F1),
        surface: lightSurface,
        background: lightBackground,
        error: errorRed,
        onPrimary: lightOnPrimary,
        onSecondary: Color(0xFF000000),
        onSurface: lightOnSurface,
        onBackground: lightOnSurface,
        onError: Color(0xFFFFFFFF),
        outline: lightOutline,
        shadow: Color(0xFF000000),
        inverseSurface: Color(0xFF313033),
        inversePrimary: Color(0xFFA8C8EC),
      ),
      textTheme: textTheme,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: lightSurface,
        foregroundColor: lightOnSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: lightOnSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: const CardThemeData(
        elevation: 2,
        shadowColor: Color(0x1A000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        color: lightSurface,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: lightOnSurface.withOpacity(0.6),
        ),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        checkColor: MaterialStateProperty.all(lightOnPrimary),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: lightSurface,
        selectedColor: primaryColor.withOpacity(0.2),
        labelStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF757575),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      
      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightOnSurface,
        contentTextStyle: const TextStyle(color: lightSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        primaryContainer: Color(0xFF1565C0),
        secondary: secondaryColor,
        secondaryContainer: Color(0xFF004D40),
        surface: darkSurface,
        background: darkBackground,
        error: errorRed,
        onPrimary: darkOnPrimary,
        onSecondary: Color(0xFF000000),
        onSurface: darkOnSurface,
        onBackground: darkOnSurface,
        onError: Color(0xFF000000),
        outline: darkOutline,
        shadow: Color(0xFF000000),
        inverseSurface: Color(0xFFE6E1E5),
        inversePrimary: primaryColor,
      ),
      textTheme: textTheme.apply(
        bodyColor: darkOnSurface,
        displayColor: darkOnSurface,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: const CardThemeData(
        elevation: 4,
        shadowColor: Color(0x4D000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        color: darkSurface,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkOnSurface.withOpacity(0.6),
        ),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        checkColor: MaterialStateProperty.all(darkOnPrimary),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkSurface,
        selectedColor: primaryColor.withOpacity(0.3),
        labelStyle: const TextStyle(fontSize: 14, color: darkOnSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF9E9E9E),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      
      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkOnSurface,
        contentTextStyle: const TextStyle(color: darkSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
