import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/enums/color_palette_type.dart';

/// Colors from Tailwind CSS (v3.0) - June 2022
///
/// https://tailwindcss.com/docs/customizing-colors

class CustomThemeData {
  CustomThemeData({required this.font, required this.paletteType}) {
    updateColorPallete(paletteType);
    updateThemeData(font);
  }
  String font;
  ColorPaletteType paletteType;
  late ThemeData lightTheme;
  late ThemeData darkTheme;

  int _primaryColor = 0xFFF3B74B;
  int _textColor = 0xFF6D4C41;
  Color errorColor = const Color(0xFFDC2626); // red-600

  late MaterialColor primarySwatch;
  late MaterialColor textSwatch;
  late ColorScheme lightColorScheme;
  late ColorScheme darkColorScheme;

  void updateColorPallete(ColorPaletteType type) {
    switch (type) {
      case ColorPaletteType.yellow:
        _primaryColor = 0xFFF3B74B;
        _textColor = 0xFF6D4C41;
        primarySwatch = MaterialColor(_primaryColor, <int, Color>{
          50: const Color(0xFFFEF9F1), // indigo-50
          100: const Color(0xFFFDF2DE), // indigo-100
          200: const Color(0xFFF9DCA7), // 토글버튼 백그라운드
          300: const Color(0xFFFAE3B9), // indigo-300
          400: const Color(0xFFF9DCA7), // indigo-400
          500: Color(_primaryColor), // indigo-500
          600: const Color(0xFF97650A), // indigo-600
          700: const Color(0xFF855809), // indigo-700
          800: const Color(0xFF724C08), // indigo-800
          900: const Color(0xFF4D3405), // dark 토글 백그라운드
        });

        textSwatch = MaterialColor(_textColor, <int, Color>{
          50: const Color(0xFFFEFEFD), // slate-50
          100: const Color(0xFFF7F3F1), // slate-100
          200: const Color(0xFFEFE7E5), // 기본 백그라운드
          300: const Color(0xFFD9C6C0), // 기본 텍스트
          400: const Color(0xFFC3A59B), // 네비게이션 텍스트
          500: Color(_textColor), // slate-500
          600: const Color(0xFF6D4C41), // 달력, 글씨 기본
          700: const Color(0xFF543B32), // slate-700
          800: const Color(0xFF30211C), // slate-800
          900: const Color(0xFF17100E), // slate-900
        });

        lightColorScheme = ColorScheme.light(
          primary: primarySwatch.shade500,
          secondary: primarySwatch.shade500,
          onSecondary: Colors.white,
          error: errorColor,
          background: textSwatch.shade200,
          onBackground: textSwatch.shade500,
          onSurface: textSwatch.shade500,
          surface: textSwatch.shade200,
          surfaceVariant: Colors.white,
          shadow: textSwatch.shade900.withOpacity(.1),
        );

        darkColorScheme = ColorScheme.dark(
          primary: primarySwatch.shade500,
          secondary: primarySwatch.shade500,
          onSecondary: Colors.white,
          error: errorColor,
          background: const Color(0xFF17100E),
          onBackground: textSwatch.shade400,
          onSurface: textSwatch.shade300,
          surface: const Color(0xFF17100E),
          surfaceVariant: const Color(0xFF282832),
          shadow: textSwatch.shade900.withOpacity(.2),
        );
        break;
      case ColorPaletteType.purple:
        _primaryColor = 0xFF6366F1;
        _textColor = 0xFF090A60;
        primarySwatch = MaterialColor(_primaryColor, <int, Color>{
          50: const Color(0xFFEEF2FF), // indigo-50
          100: const Color(0xFFE0E7FF), // indigo-100
          200: const Color(0xFFC7D2FE), // indigo-200
          300: const Color(0xFFA5B4FC), // indigo-300
          400: const Color(0xFF818CF8), // indigo-400
          500: Color(_primaryColor), // indigo-500
          600: const Color(0xFF4F46E5), // indigo-600
          700: const Color(0xFF4338CA), // indigo-700
          800: const Color(0xFF3730A3), // indigo-800
          900: const Color(0xFF312E81), // indigo-900
        });

        textSwatch = MaterialColor(_textColor, <int, Color>{
          50: const Color(0xFFF8FAFC), // slate-50
          100: const Color(0xFFF1F5F9), // slate-100
          200: const Color(0xFFE2E8F0), // slate-200
          300: const Color(0xFF94A3B8), // slate-300
          400: const Color(0xFFCFD0FB), // slate-400
          500: Color(_textColor), // slate-500
          600: const Color(0xFF475569), // slate-600
          700: const Color(0xFF334155), // slate-700
          800: const Color(0xFF1E293B), // slate-800
          900: const Color(0xFF0F172A), // slate-900
        });

        lightColorScheme = ColorScheme.light(
          primary: primarySwatch.shade500,
          secondary: primarySwatch.shade500,
          onSecondary: Colors.white,
          error: errorColor,
          background: textSwatch.shade200,
          onBackground: textSwatch.shade500,
          onSurface: textSwatch.shade500,
          surface: textSwatch.shade50,
          surfaceVariant: Colors.white,
          shadow: textSwatch.shade900.withOpacity(.1),
        );

        darkColorScheme = ColorScheme.dark(
          primary: primarySwatch.shade500,
          secondary: primarySwatch.shade500,
          onSecondary: Colors.white,
          error: errorColor,
          background: const Color(0xFF171724),
          onBackground: textSwatch.shade400,
          onSurface: textSwatch.shade300,
          surface: const Color(0xFF262630),
          surfaceVariant: const Color(0xFF282832),
          shadow: textSwatch.shade900.withOpacity(.2),
        );
        break;
      case ColorPaletteType.green:
        _primaryColor = 0xFF34D399;
        _textColor = 0xFF3B4D61;
        primarySwatch = MaterialColor(_primaryColor, <int, Color>{
          50: const Color(0xFFE5F9F2),
          100: const Color(0xFFD5F6EA),
          200: const Color(0xFFC5F2E2),
          300: const Color(0xFFB5EfDA),
          400: const Color(0xFF95E8CA),
          500: Color(_primaryColor),
          600: const Color(0xFF28B883),
          700: const Color(0xFF24A878),
          800: const Color(0xFF16674A),
          900: const Color(0xFF08271C),
        });

        textSwatch = MaterialColor(_textColor, <int, Color>{
          50: const Color(0xFFF2F5F7),
          100: const Color(0xFFDAE1E8),
          200: const Color(0xFFCED7E1),
          300: const Color(0xFFB5C3D2),
          400: const Color(0xFF91A5BC),
          500: Color(_textColor),
          600: const Color(0xFF597492),
          700: const Color(0xFF4A6079),
          800: const Color(0xFF344355),
          900: const Color(0xFF161D24),
        });

        lightColorScheme = ColorScheme.light(
          primary: primarySwatch.shade500,
          secondary: primarySwatch.shade500,
          onSecondary: Colors.white,
          error: errorColor,
          background: textSwatch.shade200,
          onBackground: textSwatch.shade500,
          onSurface: textSwatch.shade500,
          surface: textSwatch.shade200,
          surfaceVariant: Colors.white,
          shadow: textSwatch.shade900.withOpacity(.1),
        );

        darkColorScheme = ColorScheme.dark(
          primary: primarySwatch.shade500,
          secondary: primarySwatch.shade500,
          onSecondary: Colors.white,
          error: errorColor,
          background: const Color(0xFF161D24),
          onBackground: textSwatch.shade400,
          onSurface: textSwatch.shade300,
          surface: const Color(0xFF161D24),
          surfaceVariant: const Color(0xFF282832),
          shadow: textSwatch.shade900.withOpacity(.2),
        );
        break;
    }
  }

  void updateThemeData(String font) {
    this.font = font;
    if (font == 'System') {
      font = '';
    }
    lightTheme = ThemeData(
      colorScheme: lightColorScheme,
      fontFamily: font,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textSwatch.shade700,
          fontFamily: font,
        ),
        displayMedium: TextStyle(
          color: textSwatch.shade600,
          fontFamily: font,
        ),
        displaySmall: TextStyle(
          color: textSwatch.shade500,
          fontFamily: font,
        ),
        headlineLarge: TextStyle(
          color: textSwatch.shade700,
          fontFamily: font,
        ),
        headlineMedium: TextStyle(
          color: textSwatch.shade600,
          fontFamily: font,
        ),
        headlineSmall: TextStyle(
          color: textSwatch.shade500,
          fontFamily: font,
        ),
        titleLarge: TextStyle(
          color: textSwatch.shade700,
          fontFamily: font,
        ),
        titleMedium: TextStyle(
          color: textSwatch.shade600,
          fontFamily: font,
        ),
        titleSmall: TextStyle(
          color: textSwatch.shade500,
          fontFamily: font,
        ),
        bodyLarge: TextStyle(
          color: textSwatch.shade700,
          fontFamily: font,
        ),
        bodyMedium: TextStyle(
          color: textSwatch.shade600,
          fontFamily: font,
        ),
        bodySmall: TextStyle(
          color: textSwatch.shade500,
          fontFamily: font,
        ),
        labelLarge: TextStyle(
          color: textSwatch.shade700,
          fontFamily: font,
        ),
        labelMedium: TextStyle(
          color: textSwatch.shade600,
          fontFamily: font,
        ),
        labelSmall: TextStyle(
          color: textSwatch.shade500,
          fontFamily: font,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor:
            MaterialStateProperty.resolveWith<Color?>((_) => Colors.white70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.white70, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primarySwatch.shade500;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primarySwatch.shade500;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primarySwatch.shade200;
          }
          return null;
        }),
      ),
    );
    darkTheme = lightTheme.copyWith(
      colorScheme: darkColorScheme,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textSwatch.shade200,
          fontFamily: font,
        ),
        displayMedium: TextStyle(
          color: textSwatch.shade300,
          fontFamily: font,
        ),
        displaySmall: TextStyle(
          color: textSwatch.shade400,
          fontFamily: font,
        ),
        headlineLarge: TextStyle(
          color: textSwatch.shade200,
          fontFamily: font,
        ),
        headlineMedium: TextStyle(
          color: textSwatch.shade300,
          fontFamily: font,
        ),
        headlineSmall: TextStyle(
          color: textSwatch.shade400,
          fontFamily: font,
        ),
        titleLarge: TextStyle(
          color: textSwatch.shade200,
          fontFamily: font,
        ),
        titleMedium: TextStyle(
          color: textSwatch.shade300,
          fontFamily: font,
        ),
        titleSmall: TextStyle(
          color: textSwatch.shade400,
          fontFamily: font,
        ),
        bodyLarge: TextStyle(
          color: textSwatch.shade200,
          fontFamily: font,
        ),
        bodyMedium: TextStyle(
          color: textSwatch.shade300,
          fontFamily: font,
        ),
        bodySmall: TextStyle(
          color: textSwatch.shade400,
          fontFamily: font,
        ),
        labelLarge: TextStyle(
          color: textSwatch.shade200,
          fontFamily: font,
        ),
        labelMedium: TextStyle(
          color: textSwatch.shade300,
          fontFamily: font,
        ),
        labelSmall: TextStyle(
          color: textSwatch.shade400,
          fontFamily: font,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor:
            MaterialStateProperty.resolveWith<Color?>((_) => Colors.white70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.white70, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primarySwatch.shade500;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primarySwatch.shade500;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primarySwatch.shade900;
          }
          return null;
        }),
      ),
    );
  }
}
