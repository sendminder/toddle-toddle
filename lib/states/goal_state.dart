import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class GoalRecordNotifier extends StateNotifier<List<GoalRecord>> {
  GoalRecordNotifier(List<GoalRecord> state) : super(state);

  void addGoal(GoalRecord goal) {
    state = [...state, goal];
  }

  void removeGoal(GoalRecord goal) {
    state = state.where((element) => element != goal).toList();
  }

  void updateGoal(GoalRecord goal) {
    state = state.map((e) => e == goal ? goal : e).toList();
  }
}
