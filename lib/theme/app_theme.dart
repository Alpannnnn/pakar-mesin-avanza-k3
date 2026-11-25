import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Mode terang
  static const _lBg = Color(0xFFF7F8FA);
  static const _lSurface = Color(0xFFFFFFFF);
  static const _lText = Color(0xFF3A3F47);
  static const _lBorder = Color(0xFFE3E6EA);
  static const _lAccent = Color(0xFF0F766E);

  // Mode gelap (charcoal, bukan hitam pekat)
  static const _dBg = Color(0xFF1E2024);
  static const _dSurface = Color(0xFF272A30);
  static const _dText = Color(0xFFE4E6EA);
  static const _dBorder = Color(0xFF3A3E46);
  static const _dAccent = Color(0xFF2DD4BF);

  static ThemeData get lightTheme => _build(
        brightness: Brightness.light,
        bg: _lBg,
        surface: _lSurface,
        text: _lText,
        border: _lBorder,
        accent: _lAccent,
        onAccent: Colors.white,
      );

  static ThemeData get darkTheme => _build(
        brightness: Brightness.dark,
        bg: _dBg,
        surface: _dSurface,
        text: _dText,
        border: _dBorder,
        accent: _dAccent,
        onAccent: const Color(0xFF0B2B27),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color text,
    required Color border,
    required Color accent,
    required Color onAccent,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      secondary: accent,
      onSecondary: onAccent,
      error: const Color(0xFFD64545),
      onError: Colors.white,
      surface: surface,
      onSurface: text,
      outline: border,
      outlineVariant: border,
    );

    final baseText =
        ThemeData(brightness: brightness, useMaterial3: true).textTheme;
    final textTheme = baseText
        .apply(bodyColor: text, displayColor: text)
        .copyWith(
          headlineMedium: baseText.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w600, color: text),
          titleMedium: baseText.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600, color: text),
          bodyMedium: baseText.bodyMedium?.copyWith(height: 1.45, color: text),
        );

    final radius = BorderRadius.circular(12);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      dividerColor: border,
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(fontSize: 18),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: accent, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: border, width: 1),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: text),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: border,
      ),
    );
  }
}