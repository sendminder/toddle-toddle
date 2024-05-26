import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:flutter/material.dart';

final AutoDisposeChangeNotifierProvider<FontState> fontProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<FontState> ref) {
  return FontState();
});

class FontState extends ChangeNotifier {
  FontState() {
    font = Hive.box(hivePrefBox).get('font', defaultValue: 'System') as String;
  }
  late String font;

  String get getFont => font;

  void setFont(String font) {
    this.font = font;
    Hive.box(hivePrefBox).put('font', font);
    notifyListeners();
  }
}
