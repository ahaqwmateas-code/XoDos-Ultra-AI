// cyan_theme.dart
import 'package:flutter/material.dart';

class CyanTheme {
  // Cyan/Ice-Blue Color Palette
  static const Color primaryCyan = Color(0xFF00D9FF);      // Bright cyan
  static const Color darkCyan = Color(0xFF0099CC);         // Dark cyan
  static const Color iceBlueDark = Color(0xFF004D7A);      // Ice blue dark
  static const Color lightCyan = Color(0xFF66F0FF);        // Light cyan
  static const Color accentCyan = Color(0xFF00B8D4);       // Accent cyan
  
  // Supporting colors
  static const Color darkBackground = Color(0xFF0A0E27);   // Very dark blue-black
  static const Color cardBackground = Color(0xFF1A2332);   // Dark card background
  static const Color surfaceColor = Color(0xFF0F1419);     // Surface color
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);      // White
  static const Color textSecondary = Color(0xFF99CCDD);    // Light cyan text
  static const Color textTertiary = Color(0xFF66AACC);     // Medium cyan text
  
  /// Get the full cyan-themed ThemeData for light mode
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryCyan,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: primaryCyan,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: primaryCyan,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardBackground,
        indicatorColor: primaryCyan,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primaryCyan);
          }
          return const IconThemeData(color: textSecondary);
        }),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: primaryCyan, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryCyan),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkCyan, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryCyan, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textTertiary),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryCyan,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCyan,
          foregroundColor: darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCyan,
          side: const BorderSide(color: primaryCyan, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryCyan,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryCyan;
          }
          return textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryCyan.withOpacity(0.3);
          }
          return darkCyan.withOpacity(0.2);
        }),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: cardBackground,
        collapsedBackgroundColor: surfaceColor,
        textColor: primaryCyan,
        collapsedTextColor: textSecondary,
        iconColor: primaryCyan,
        collapsedIconColor: textSecondary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textTertiary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textTertiary),
        labelLarge: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textTertiary),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryCyan,
        secondary: accentCyan,
        tertiary: lightCyan,
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
  
  /// Get the full cyan-themed ThemeData for dark mode
  static ThemeData getDarkTheme() {
    return getLightTheme(); // Same as light theme since we're using dark colors
  }
  
  /// Get a gradient decoration with cyan colors
  static BoxDecoration getCyanGradientDecoration() {
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
      border: Border.all(color: primaryCyan.withOpacity(0.3), width: 1),
    );
  }
  
  /// Get a cyan-themed button style
  static ButtonStyle getCyanButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryCyan,
      foregroundColor: darkBackground,
      elevation: 4,
      shadowColor: primaryCyan.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
  
  /// Get a cyan-themed text style
  static TextStyle getCyanTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = primaryCyan,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
    );
  }
}
