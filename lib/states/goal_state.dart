import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:collection/collection.dart';

final goalRecordsStateProvider =
    StateNotifierProvider<GoalState, List<Goal>>((ref) {
  return GoalState();
});

class GoalState extends StateNotifier<List<Goal>> {
  GoalState() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    final box = await Hive.openBox<Goal>(HiveGoalBox);
    state = box.values.toList();
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

  // GoalRecord 객체 추가 또는 업데이트
  Future<void> addOrUpdateGoalRecord(Goal goalRecord) async {
    final box = await Hive.openBox<Goal>(HiveGoalBox);
    await box.put(goalRecord.id, goalRecord); // ID를 사용하여 저장
    state = [...state, goalRecord]; // 상태 갱신
  }

  // 특정 GoalRecord 삭제
  Future<void> removeGoalRecord(String id) async {
    final box = await Hive.openBox<Goal>(HiveGoalBox);
    await box.delete(id); // ID를 사용하여 삭제
    state = state.where((goalRecord) => goalRecord.id != id).toList(); // 상태 갱신
  }

  // 특정 Goal id의 Achievement를 수정하거나 추가하는 함수
  Future<void> addOrUpdateAchievement(
      String goalId, DateTime date, bool achieved) async {
    final box = await Hive.openBox<Goal>(HiveGoalBox);
    Goal? goal = getGoalById(goalId);
    if (goal != null) {
      Achievement? existingAchievement = goal.achievements.firstWhereOrNull(
        (achievement) => achievement.date == date,
      );
      if (existingAchievement != null) {
        // 해당 날짜의 Achievement가 존재하면, achieved 값을 업데이트
        existingAchievement.achieved = achieved;
        await existingAchievement.save(); // 변경 사항을 Hive에 저장
      } else {
        // 해당 날짜의 Achievement가 존재하지 않으면, 새로운 Achievement를 추가
        Achievement newAchievement =
            Achievement(date: date, achieved: achieved);
        goal.achievements.add(newAchievement);
        await newAchievement.save(); // 새로운 Achievement를 Hive에 저장
      }
      await box.put(goalId, goal); // 변경 사항을 저장
      state = List.from(state); // 상태 갱신
    }
  }
}
