import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';

final goalsStateProvider = StateNotifierProvider<GoalsState, List<Goal>>((ref) {
  return GoalsState();
});

class GoalsState extends StateNotifier<List<Goal>> {
  final logger = GetIt.I<Logger>();

  GoalsState() : super([]) {
    _initialize();
    sort();
    printAll();
  }

  void printAll() async {
    final box = Hive.box<Goal>(HiveGoalBox);
    for (int i = 0; i < box.length; i++) {
      var item = box.getAt(i)!;
      logger.d(item.toJson());
    }
  }

  Future<void> _initialize() async {
    final box = await Hive.openBox<Goal>(HiveGoalBox);
    state = box.values.toList();
  }

  bool isExist(String id) {
    final box = Hive.box<Goal>(HiveGoalBox);
    return box.get(id) == null;
  }

  // Goal을 id 기준으로 조회하는 함수
  Goal? getGoalById(String id) {
    try {
      return state.firstWhere((goal) => goal.id == id);
    } catch (e) {
      // 해당하는 ID의 Goal이 없을 경우 null을 반환
      return null;
    }
  }

  // Goal 객체 추가 또는 업데이트
  Future<void> addOrUpdateGoal(Goal goal) async {
    final box = Hive.box<Goal>(HiveGoalBox);
    await box.put(goal.id, goal); // ID를 사용하여 저장
    state = [...state, goal]; // 상태 갱신
  }

  // 특정 Goal 삭제
  Future<void> removeGoal(String id) async {
    final box = Hive.box<Goal>(HiveGoalBox);
    await box.delete(id); // ID를 사용하여 삭제
    state = state.where((goal) => goal.id != id).toList(); // 상태 갱신
  }

  // 특정 Goal id의 Achievement를 수정하거나 추가하는 함수
  Future<void> addOrUpdateAchievement(
      String goalId, DateTime date, bool achieved) async {
    final box = Hive.box<Goal>(HiveGoalBox);
    Goal? goal = getGoalById(goalId);
    if (goal != null) {
      final existingAchievement = goal.findAchievementByDate(date);
      if (existingAchievement != null) {
        // 해당 날짜의 Achievement가 존재하면, achieved 값을 업데이트
        existingAchievement.updateAchieved(achieved);
      } else {
        // 해당 날짜의 Achievement가 존재하지 않으면, 새로운 Achievement를 추가
        Achievement newAchievement =
            Achievement(date: date, achieved: achieved);
        await goal.addAchievement(newAchievement);
      }
      // 변경 사항을 저장
      await box.put(goalId, goal);
      // 상태 갱신
      state = List.from(state);
    }
  }

  // 특정 Goal id의 Schedule을 수정하는 함수
  Future<void> updateSchedule(String goalId, List<int> daysOfWeek,
      String notificationTime, DateTime startDate, bool isDaily) async {
    final box = Hive.box<Goal>(HiveGoalBox);
    Goal? goal = getGoalById(goalId);
    if (goal != null) {
      await goal.schedule.updateDaysOfWeek(daysOfWeek);
      await goal.schedule.updateNotificationTime(notificationTime);
      await goal.schedule.updateStartDate(startDate);
      await goal.schedule.updateIsDaily(isDaily);
      // 변경 사항을 저장
      await box.put(goalId, goal);
      // 상태 갱신
      state = List.from(state);
    }
  }

  void sort() {
    state.sort((a, b) {
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;
      return a.startTime!.compareTo(b.startTime!);
    });
  }
}
