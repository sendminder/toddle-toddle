import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final AutoDisposeChangeNotifierProvider<FocusedTimeState> focusedTimeProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<FocusedTimeState> ref) {
  return FocusedTimeState();
});

class FocusedTimeState extends ChangeNotifier {
  FocusedTimeState() {
    focusedTime = DateTime.now();
  }

  late DateTime focusedTime;

  get getfocusedTime => focusedTime;

  void setFocusedTime(DateTime value) {
    focusedTime = value;
    notifyListeners();
  }

  void dayCountUp() {
    if (!isSameDay(DateTime.now(), focusedTime)) {
      focusedTime = focusedTime.add(const Duration(days: 1));
      notifyListeners();
    }
  }

  void dayCountDown() {
    focusedTime = focusedTime.add(const Duration(days: -1));
    notifyListeners();
  }
}
