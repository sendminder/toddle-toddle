import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalFilterProvider = StateNotifierProvider<GoalFilterState, bool>((ref) {
  return GoalFilterState();
});

class GoalFilterState extends StateNotifier<bool> {
  GoalFilterState() : super(false);

  void toggle() {
    state = !state;
  }

  void set(bool value) {
    state = value;
  }
}
