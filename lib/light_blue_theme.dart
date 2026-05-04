// light_blue_theme.dart - Light Blue Theme for XoDos Ultra AI
import 'package:flutter/material.dart';

class LightBlueTheme {
  // Light Blue Color Palette
  static const Color primaryLightBlue = Color(0xFF00B4D8);    // Bright light blue
  static const Color accentBlue = Color(0xFF0096C7);          // Accent blue
  static const Color skyBlue = Color(0xFF48CAE4);             // Sky blue
  static const Color lightSkyBlue = Color(0xFF90E0EF);        // Light sky blue
  static const Color veryLightBlue = Color(0xFFCAF0F8);       // Very light blue
  
  // Background colors
  static const Color darkBackground = Color(0xFF0A1628);      // Dark background
  static const Color cardBackground = Color(0xFF1A2B3D);      // Card background
  static const Color surfaceColor = Color(0xFF0F1F2E);        // Surface color
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);         // White
  static const Color textSecondary = Color(0xFF90E0EF);       // Light blue text
  static const Color textTertiary = Color(0xFF48CAE4);        // Medium blue text
  
  /// Get the full light blue themed ThemeData
  static ThemeData getLightBlueTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryLightBlue,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: primaryLightBlue,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: primaryLightBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardBackground,
        indicatorColor: primaryLightBlue,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primaryLightBlue);
          }
          return const IconThemeData(color: textSecondary);
        }),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: primaryLightBlue, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryLightBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentBlue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryLightBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textTertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLightBlue,
          foregroundColor: darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLightBlue,
          side: const BorderSide(color: primaryLightBlue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryLightBlue;
          }
          return textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryLightBlue.withOpacity(0.3);
          }
          return accentBlue.withOpacity(0.2);
        }),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textTertiary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textTertiary),
        labelLarge: TextStyle(color: primaryLightBlue, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textTertiary),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryLightBlue,
        secondary: accentBlue,
        tertiary: skyBlue,
        surface: cardBackground,
        background: darkBackground,
        error: const Color(0xFFFF6B6B),
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),
    );
  }
  
  /// Get a gradient decoration with light blue colors
  static BoxDecoration getLightBlueGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          darkBackground,
          cardBackground.withOpacity(0.8),
          darkBackground,
        ],
      ),
      border: Border.all(color: primaryLightBlue.withOpacity(0.3), width: 1),
    );
  }
  
  /// Get a light blue themed button style
  static ButtonStyle getLightBlueButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryLightBlue,
      foregroundColor: darkBackground,
      elevation: 4,
      shadowColor: primaryLightBlue.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
  
  /// Get a light blue themed text style
  static TextStyle getLightBlueTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = primaryLightBlue,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
    );
  }
}
