import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF3B5BFE); // Blue chính
  static const Color secondary = Color(0xFF273671); // Blue phụ (nút phụ, icon)
  static const Color background = Color(0xFFF5F6FA); // Nền toàn bộ app
  static const Color surface = Color(0xFFFFFFFF); // Card, input, form
  static const Color textPrimary = Color(0xFF1C1C1E); // Text chính (title)
  static const Color textSecondary = Color(
    0xFFA0A4A8,
  ); // Text phụ (hint, label phụ)
  static const Color border = Color(0xFFE5E5E5); // Viền input, card
  static const Color success = Color(0xFF4CAF50); // Trạng thái Success
  static const Color warning = Color(0xFFFFC107); // Trạng thái Pending
  static const Color error = Color(0xFFF44336); // Trạng thái Rejected
  static const Color hint = Color(0xFFB0B0B0); // Hint text trong input
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // seed color theme
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

      // scaffold color
      scaffoldBackgroundColor: AppColors.background,

      // app bar theme color
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary, // màu icon (nút back, nút settings,...)
        ),
      ),

      // text theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        // Tiêu đề lớn (Welcome)
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1,
        ),

        // Tiêu đề phụ
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1,
        ),

        // Logo
        displaySmall: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        // Name account, Job Title
        headlineLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1,
        ),

        // Section Title ("Feature Job" "Recommended", "Applied", "Category")
        headlineMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1,
        ),

        // Job Description, Qualification, Banner Title, Card Title
        headlineSmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        // Title TextField, Greeting text
        titleLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1
        ),

        // Sign In, Sign Up, Label Button Small
        titleMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.surface,
        ),

        // Label Chip
        titleSmall: const TextStyle(
          fontSize: 13,
          color: AppColors.surface,
        ),

        // Label Setting
        bodyLarge: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),

        // Short Text
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),

        // Location Card, Text Banner, Rating, Category Label
        bodySmall: const TextStyle(
            fontSize: 13,
            color: AppColors.textPrimary,
        ),

        // Hint TextField Login, Sign up, Search
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: AppColors.hint,
        ),

        // Label Button Profile
        labelMedium: const TextStyle(
          fontSize: 15,
          color: AppColors.surface,
        ),

        // Hint Company, hint Email, Hint TextFieldForm
        labelSmall: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.hint
        ),
      ),

      // input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: EdgeInsets.symmetric(vertical: 14),
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
