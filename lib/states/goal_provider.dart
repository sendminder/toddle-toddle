import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<GoalState> goalProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<GoalState> ref) {
  return GoalState();
});

class GoalState with ChangeNotifier {
  Goal _goal = Goal.newDefaultGoal();

  Goal get goal => _goal;

  bool inited = false;

  void initGoal(Goal initGoal) {
    if (!inited) {
      _goal = initGoal;
      inited = true;
    }
  }

  void updateName(String name) {
    _goal.name = name;
    notifyListeners();
  }

  void updateColor(Color color) {
    _goal.color = color;
    notifyListeners();
  }

  void updateStartDate(DateTime date) {
    _goal.startDate = date;
    notifyListeners();
  }

  void updateIsDaily(bool value) {
    _goal.schedule.isDaily = value;
    notifyListeners();
  }

  void updateNotificationTime(String time) {
    _goal.schedule.notificationTime = time;
    notifyListeners();
  }

  void updateNeedPush(bool value) {
    _goal.needPush = value;
    notifyListeners();
  }

  void updateSelectedDays(List<int> days) {
    _goal.schedule.daysOfWeek = days;
    notifyListeners();
  }
}
