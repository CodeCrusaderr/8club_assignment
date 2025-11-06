import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color text1 = Color(0xFFFFFFFF);
  static const Color text2 = Color(0xB8FFFFFF); // 72%
  static const Color text3 = Color(0x7AFFFFFF); // 48%
  static const Color text4 = Color(0x3DFFFFFF); // 24%
  static const Color text5 = Color(0x3DFFFFFF); // 24%

  static const Color base1 = Color(0xFF101010);
  static const Color base2 = Color(0xFF151515);

  static const Color surfaceWhite1 = Color(0x05FFFFFF); // 2%
  static const Color surfaceWhite2 = Color(0x0DFFFFFF); // 5%
  static const Color surfaceBlack1 = Color(0xE6101010); // 90%
  static const Color surfaceBlack2 = Color(0xB3101010); // 70%
  static const Color surfaceBlack3 = Color(0x80101010); // 50%

  static const Color primaryAccent = Color(0xFF9196FF);
  static const Color secondaryAccent = Color(0xFF5961FF);
  static const Color positive = Color(0xFFFE5BDB);
  static const Color negative = Color(0xFFC22743);

  static const List<Color> borderGradient = [
    Color(0x00FFFFFF), // start transparent for gradient type per spec
    Color(0x14FFFFFF), // 8%
    Color(0x29FFFFFF), // 16%
    Color(0x3DFFFFFF), // 24%
  ];
}

class AppTheme {
  static TextTheme _textTheme() {
    final base = GoogleFonts.spaceGroteskTextTheme();

    TextStyle h1Bold = base.headlineSmall!.copyWith(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.03 * 28,
      color: AppColors.text1,
    );
    TextStyle h1Regular = base.headlineSmall!.copyWith(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.03 * 28,
      color: AppColors.text1,
    );
    TextStyle h2Bold = base.titleLarge!.copyWith(
      fontSize: 24,
      height: 30 / 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02 * 24,
      color: AppColors.text1,
    );
    TextStyle h2Regular = base.titleLarge!.copyWith(
      fontSize: 24,
      height: 30 / 24,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.02 * 24,
      color: AppColors.text1,
    );
    TextStyle h3Bold = base.titleMedium!.copyWith(
      fontSize: 20,
      height: 26 / 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.01 * 20,
      color: AppColors.text1,
    );
    TextStyle h3Regular = base.titleMedium!.copyWith(
      fontSize: 20,
      height: 26 / 20,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.01 * 20,
      color: AppColors.text1,
    );
    TextStyle b1Bold = base.bodyLarge!.copyWith(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      color: AppColors.text1,
    );
    TextStyle b1Regular = base.bodyLarge!.copyWith(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.text2,
    );
    TextStyle b2Bold = base.bodyMedium!.copyWith(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      color: AppColors.text1,
    );
    TextStyle b2Regular = base.bodyMedium!.copyWith(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.text3,
    );
    TextStyle s1Regular = base.bodySmall!.copyWith(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.text3,
    );
    TextStyle s2 = base.labelSmall!.copyWith(
      fontSize: 10,
      height: 12 / 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.text4,
    );

    return TextTheme(
      displayLarge: h1Bold,
      displayMedium: h1Regular,
      headlineLarge: h2Bold,
      headlineMedium: h2Regular,
      titleLarge: h3Bold,
      titleMedium: h3Regular,
      bodyLarge: b1Regular,
      bodyMedium: b2Regular,
      bodySmall: s1Regular,
      labelSmall: s2,
    );
  }

  static ThemeData buildThemeData() {
    final textTheme = _textTheme();
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.white24, width: 1),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.base1,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.surfaceBlack2,
        background: AppColors.base1,
        error: AppColors.negative,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceBlack3,
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.text4),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterStyle: textTheme.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryAccent,
          foregroundColor: AppColors.text1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 6,
          shadowColor: AppColors.secondaryAccent.withOpacity(0.4),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceBlack2,
        elevation: 6,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      useMaterial3: true,
    );
  }
}


