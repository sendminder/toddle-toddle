import 'package:flutter/material.dart';

/// Colors from Tailwind CSS (v3.0) - June 2022
///
/// https://tailwindcss.com/docs/customizing-colors

const int _primaryColor = 0xFF6366F1;
const MaterialColor primarySwatch = MaterialColor(_primaryColor, <int, Color>{
  50: Color(0xFFEEF2FF), // indigo-50
  100: Color(0xFFE0E7FF), // indigo-100
  200: Color(0xFFC7D2FE), // indigo-200
  300: Color(0xFFA5B4FC), // indigo-300
  400: Color(0xFF818CF8), // indigo-400
  500: Color(_primaryColor), // indigo-500
  600: Color(0xFF4F46E5), // indigo-600
  700: Color(0xFF4338CA), // indigo-700
  800: Color(0xFF3730A3), // indigo-800
  900: Color(0xFF312E81), // indigo-900
});

const int _textColor = 0xFF64748B;
const MaterialColor textSwatch = MaterialColor(_textColor, <int, Color>{
  50: Color(0xFFF8FAFC), // slate-50
  100: Color(0xFFF1F5F9), // slate-100
  200: Color(0xFFE2E8F0), // slate-200
  300: Color(0xFFCBD5E1), // slate-300
  400: Color(0xFF94A3B8), // slate-400
  500: Color(_textColor), // slate-500
  600: Color(0xFF475569), // slate-600
  700: Color(0xFF334155), // slate-700
  800: Color(0xFF1E293B), // slate-800
  900: Color(0xFF0F172A), // slate-900
});

const Color errorColor = Color(0xFFDC2626); // red-600

final ColorScheme lightColorScheme = ColorScheme.light(
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

final ColorScheme darkColorScheme = ColorScheme.dark(
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

// const int _primaryColor = 0xFFF3B74B;
// const MaterialColor primarySwatch = MaterialColor(_primaryColor, <int, Color>{
//   50: Color(0xFFFFF8E7), // 밝은 색상
//   100: Color(0xFFFFECB3), // 연한 색상
//   200: Color(0xFFFFE08F), // 연한 색상
//   300: Color(0xFFFFD26B), // 중간 색상
//   400: Color(0xFFFFC657), // 중간 색상
//   500: Color(_primaryColor), // 기본 색상
//   600: Color(0xFFE0A745), // 어두운 색상
//   700: Color(0xFFC28F3E), // 어두운 색상
//   800: Color(0xFFA57837), // 어두운 색상
//   900: Color(0xFF885E30), // 매우 어두운 색상
// });

// const int _textColor = 0xFF6D4C41; // 갈색 계열 색상으로 변경
// const MaterialColor textSwatch = MaterialColor(_textColor, <int, Color>{
//   50: Color(0xFFF0EDEC), // 연한 베이지
//   100: Color(0xFFF0EDEC), // 연한 베이지
//   200: Color(0xFFE1DBD9), // home background
//   300: Color(0xFF8A6F66), // 주황색
//   400: Color(0xff7b5d54), // 주황색
//   500: Color(_textColor), // 기본 색상
//   600: Color(0xFF62443A), // 중간 브라운
//   700: Color(0xFF4C352D), // 중간 브라운
//   800: Color(0xFF362620), // 어두운 브라운
//   900: Color(0xFF2B1E1A), // 매우 어두운 브라운
// });

// const Color errorColor = Color(0xFFDC2626); // red-600

// final ColorScheme lightColorScheme = ColorScheme.light(
//   primary: primarySwatch.shade500,
//   secondary: primarySwatch.shade500,
//   onSecondary: Colors.white,
//   error: errorColor,
//   background: textSwatch.shade200,
//   onBackground: textSwatch.shade500,
//   onSurface: textSwatch.shade500,
//   surface: textSwatch.shade50,
//   surfaceVariant: Colors.white,
//   shadow: textSwatch.shade900.withOpacity(.1),
// );

// final ColorScheme darkColorScheme = ColorScheme.dark(
//   primary: primarySwatch.shade500,
//   secondary: primarySwatch.shade500,
//   onSecondary: Colors.white,
//   error: errorColor,
//   background: textSwatch.shade900,
//   onBackground: textSwatch.shade400,
//   onSurface: textSwatch.shade300,
//   surface: const Color(0xFF262630),
//   surfaceVariant: const Color(0xFF282832),
//   shadow: textSwatch.shade900.withOpacity(.2),
// );

class CustomThemeData {
  CustomThemeData({required this.font}) {
    updateThemeData(font);
  }
  String font;
  late ThemeData lightTheme;
  late ThemeData darkTheme;

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
