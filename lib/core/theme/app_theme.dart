import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';

class AppTheme {
  // Futuristic Colors 2080
  static const Color neonBlue = Color(0xFF00D4FF);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color cyberYellow = Color(0xFFFFD700);
  static const Color holographicWhite = Color(0xFFF8FAFC);
  static const Color metallicGray = Color(0xFF1E293B);
  static const Color darkSpace = Color(0xFF0F172A);
  static const Color glowingAccent = Color(0xFF06B6D4);
  
  // Gradients
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonBlue, neonPurple, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient holographicGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF1F5F9),
      Color(0xFFE2E8F0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
      Color(0xFF334155),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: neonBlue,
        secondary: neonPurple,
        tertiary: neonPink,
        surface: holographicWhite,
        background: Color(0xFFF8FAFC),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: metallicGray,
        onBackground: metallicGray,
        outline: Color(0xFFE2E8F0),
        surfaceVariant: Color(0xFFF1F5F9),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: metallicGray,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: metallicGray),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      
      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: metallicGray,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: metallicGray,
          letterSpacing: 1.2,
        ),
        headlineLarge: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: metallicGray,
          letterSpacing: 1.0,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: metallicGray,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: metallicGray,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: metallicGray,
          height: 1.5,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: neonBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: Colors.white.withOpacity(0.7),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: neonBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: neonBlue,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.poppins(color: metallicGray),
        hintStyle: GoogleFonts.poppins(
          color: metallicGray.withOpacity(0.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.9),
        selectedItemColor: neonBlue,
        unselectedItemColor: metallicGray.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: neonBlue,
        secondary: neonPurple,
        tertiary: neonPink,
        surface: Color(0xFF1E293B),
        background: darkSpace,
        onPrimary: darkSpace,
        onSecondary: darkSpace,
        onSurface: holographicWhite,
        onBackground: holographicWhite,
        outline: Color(0xFF475569),
        surfaceVariant: Color(0xFF334155),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: holographicWhite,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: holographicWhite),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      
      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: holographicWhite,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: holographicWhite,
          letterSpacing: 1.2,
        ),
        headlineLarge: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: holographicWhite,
          letterSpacing: 1.0,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: holographicWhite,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: holographicWhite,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: holographicWhite,
          height: 1.5,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: neonBlue.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: const Color(0xFF1E293B).withOpacity(0.8),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: neonBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: neonBlue,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.poppins(color: holographicWhite),
        hintStyle: GoogleFonts.poppins(
          color: holographicWhite.withOpacity(0.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E293B).withOpacity(0.9),
        selectedItemColor: neonBlue,
        unselectedItemColor: holographicWhite.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Theme Provider
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Locale Provider
class LocaleProvider extends ChangeNotifier {
  Locale _locale = AppConfig.defaultLocale;
  
  Locale get locale => _locale;
  
  bool get isArabic => _locale.languageCode == 'ar';
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
  
  void toggleLocale() {
    _locale = _locale.languageCode == 'ar' 
        ? const Locale('en', 'US')
        : const Locale('ar', 'SA');
    notifyListeners();
  }
}