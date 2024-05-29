import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:toddle_toddle/config/theme.dart';

final AutoDisposeChangeNotifierProvider<ThemeModeState> themeProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<ThemeModeState> ref) {
  return ThemeModeState();
});

class ThemeModeState extends ChangeNotifier {
  ThemeModeState() {
    final String mode = Hive.box(hivePrefBox)
        .get('themeMode', defaultValue: ThemeMode.system.toString()) as String;
    switch (mode) {
      case 'ThemeMode.dark':
        themeMode = ThemeMode.dark;
        break;
      case 'ThemeMode.light':
        themeMode = ThemeMode.light;
        break;
      case 'ThemeMode.system':
        themeMode = ThemeMode.system;
        break;
    }

    final ColorPaletteType colorPalette = Hive.box(hivePrefBox)
        .get('colorPaletteType', defaultValue: ColorPaletteType.yellow);
    colorPaletteType = colorPalette;
  }

  late ThemeMode themeMode;
  late ColorPaletteType colorPaletteType;

  get currentThemeMode => themeMode;
  get currentColorPaletteType => colorPaletteType;

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    Hive.box(hivePrefBox).put('themeMode', themeMode.toString());
    notifyListeners();
  }

  void setColorPaletteType(ColorPaletteType type) {
    colorPaletteType = type;
    Hive.box(hivePrefBox).put('colorPaletteType', type);
    notifyListeners();
  }
}
