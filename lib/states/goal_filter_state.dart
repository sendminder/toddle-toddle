import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';

final AutoDisposeChangeNotifierProvider<GoalFilterState> goalFilterProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<GoalFilterState> ref) {
  return GoalFilterState();
});

class GoalFilterState extends ChangeNotifier {
  GoalFilterState() {
    filterType = Hive.box(hivePrefBox)
        .get('goalFilterType', defaultValue: GoalFilterType.all);
  }

  late GoalFilterType filterType;

  get type => filterType;

  void setFilterType(GoalFilterType type) {
    filterType = type;
    Hive.box(hivePrefBox).put('goalFilterType', type);
    notifyListeners();
  }
}
