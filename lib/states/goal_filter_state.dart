import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';

final AutoDisposeChangeNotifierProvider<GoalFilterState> goalFilterProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<GoalFilterState> ref) {
  return GoalFilterState();
});

class GoalFilterState extends ChangeNotifier {
  GoalFilterState() {
    filterType = Hive.box(hivePrefBox)
        .get('goalFilterType', defaultValue: FilterType.all);
  }

  FilterType? filterType;

  get type => filterType;

  void setFilterType(FilterType type) {
    filterType = type;
    Hive.box(hivePrefBox).put('goalFilterType', type);
    notifyListeners();
  }
}

enum FilterType {
  all,
  active,
  completed,
}
