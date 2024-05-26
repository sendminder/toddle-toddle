import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';
import 'package:toddle_toddle/service/local_push_service.dart';

final StateNotifierProvider<GoalsState, List<Goal>> goalsStateProvider =
    StateNotifierProvider<GoalsState, List<Goal>>((ref) {
  var state = GoalsState();
  // 비동기로 상태를 로드하고 설정
  state.createSorted().then((initializedState) {
    ref.read(goalsStateProvider.notifier).state = initializedState.state;
  });
  return state;
});

class GoalsState extends StateNotifier<List<Goal>> {
  final logger = GetIt.I<Logger>();
  final localPushService = GetIt.I<LocalPushService>();
  final int syncInterval = 60 * 60 * 6;

  GoalsState() : super([]);

  Future<GoalsState> createSorted() async {
    var state = GoalsState();
    await state._initialize();
    await state.sort();
    state.printAll();
    return state;
  }

  void printAll() async {
    for (int i = 0; i < state.length; i++) {
      var item = state[i];
      logger.d(item.toJson());
    }
  }

  Future<void> _initialize() async {
    final box = await Hive.openBox<Goal>(hiveGoalBox);
    state = box.values.toList();

    final int scheduleSyncTime =
        await Hive.box(hivePrefBox).get('scheduleSyncTime', defaultValue: 0);
    int nowSecond = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (scheduleSyncTime == 0 || scheduleSyncTime + syncInterval < nowSecond) {
      await syncSchedule();
      await Hive.box(hivePrefBox).put('scheduleSyncTime', nowSecond);
    }
  }

  bool isExist(int id) {
    final box = Hive.box<Goal>(hiveGoalBox);
    return box.get(id) != null;
  }

  // Goal을 id 기준으로 조회하는 함수
  Goal? getGoalById(int id) {
    try {
      return state.firstWhere((goal) => goal.id == id);
    } catch (e) {
      // 해당하는 ID의 Goal이 없을 경우 null을 반환
      return null;
    }
  }

  // Goal 객체 추가 또는 업데이트
  Future<void> addOrUpdateGoal(Goal goal) async {
    final box = Hive.box<Goal>(hiveGoalBox);
    if (isExist(goal.id)) {
      // Goal이 이미 존재하면 업데이트
      await box.put(goal.id, goal);
      state = state.map((g) => g.id == goal.id ? goal : g).toList();
      await sort();
    } else {
      // Goal이 존재하지 않으면 추가
      await box.put(goal.id, goal);
      state = [...state, goal];
      await sort();
    }
    await updatePushSchedule(goal.id);
  }

  // 특정 Goal 삭제
  Future<void> removeGoal(int id) async {
    final box = Hive.box<Goal>(hiveGoalBox);
    Goal? goal = getGoalById(id);
    if (goal != null) {
      await cancelSchedule(goal.id);
      await box.delete(id); // ID를 사용하여 삭제
    }
    state = state.where((goal) => goal.id != id).toList(); // 상태 갱신
  }

  // 특정 Goal done 상태 업데이트
  Future<void> doneGoal(int id) async {
    final box = Hive.box<Goal>(hiveGoalBox);
    Goal? goal = getGoalById(id);
    if (goal != null) {
      var now = DateTime.now();
      goal.isEnd = true;
      goal.endTime = DateTime(now.year, now.month, now.day);
      await box.put(id, goal);
      await cancelSchedule(goal.id);
      state = List.from(state);
    }
  }

  // 특정 Goal done 상태 업데이트
  Future<void> recoverGoal(int id) async {
    final box = Hive.box<Goal>(hiveGoalBox);
    Goal? goal = getGoalById(id);
    if (goal != null) {
      goal.isEnd = false;
      goal.endTime = null;
      await box.put(id, goal);
      await updatePushSchedule(goal.id);
      state = List.from(state);
    }
  }

  Future<void> toggleNeedPush(int id) async {
    final box = Hive.box<Goal>(hiveGoalBox);
    Goal? goal = getGoalById(id);
    if (goal != null) {
      goal.needPush = !goal.needPush;
      await box.put(id, goal);
      await updatePushSchedule(goal.id);
      state = List.from(state);
    }
  }

  // 특정 Goal id의 Achievement를 수정하거나 추가하는 함수
  Future<void> addOrUpdateAchievement(
      int goalId, DateTime date, bool achieved) async {
    final box = Hive.box<Goal>(hiveGoalBox);
    Goal? goal = getGoalById(goalId);
    if (goal != null) {
      final existingAchievement = goal.findAchievementByDate(date);
      if (existingAchievement != null) {
        // 해당 날짜의 Achievement가 존재하면, achieved 값을 업데이트
        if (achieved) {
          existingAchievement.updateAchieved(achieved);
        } else {
          goal.deleteAchievement(date);
        }
      } else {
        // 해당 날짜의 Achievement가 존재하지 않으면, 새로운 Achievement를 추가
        if (achieved) {
          Achievement newAchievement =
              Achievement(date: date, achieved: achieved);
          await goal.addAchievement(newAchievement);
        }
      }
      // 변경 사항을 저장
      await box.put(goalId, goal);
      // 상태 갱신
      state = List.from(state);
    }
  }

  Future<void> syncSchedule() async {
    await localPushService.cancelAll();
    for (int i = 0; i < state.length; i++) {
      var goal = state[i];
      await _updatePushSchedule(goal, false);
    }
  }

  Future<void> cancelSchedule(int goalId) async {
    var goal = getGoalById(goalId);
    if (goal != null) {
      for (int j = 0; j < 7; j++) {
        await localPushService.cancelNotification(goal.id + j);
        logger.d('cancelNotification: ${goal.id + j}');
      }
    }
  }

  Future<void> cancelAllSchedule() async {
    await localPushService.cancelAll();
    logger.d('cancelAllSchedule');
  }

  Future<void> updatePushSchedule(int goalId) async {
    var goal = getGoalById(goalId);
    if (goal != null) await _updatePushSchedule(goal, true);
  }

  Future<void> _updatePushSchedule(Goal goal, bool needCancle) async {
    var daysOfWeek = goal.schedule.daysOfWeek;
    if (goal.schedule.isDaily) {
      daysOfWeek = [0, 1, 2, 3, 4, 5, 6];
    }
    if (needCancle) {
      for (int j = 0; j < 7; j++) {
        await localPushService.cancelNotification(goal.id + j);
        logger.d('cancelNotification: ${goal.id + j}');
      }
    }

    // 목표가 종료됐거나 알림 off인 경우 알림을 설정하지 않음
    if (goal.isEnd || !goal.needPush) {
      logger.d('${goal.name} is end');
      return;
    }

    // 시작 시간이
    // null 이거나 현재보다 이전이면 현재날로 설정
    // 현재보다 미래이면 시작 시간으로 설정
    var scheduleStartDate = DateTime.now();
    if (scheduleStartDate.isBefore(goal.startDate)) {
      scheduleStartDate = goal.startDate;
    }

    final hour = goal.schedule.notificationTimeHour();
    final minute = goal.schedule.notificationTimeMinute();
    final ampm = goal.schedule.notificationTime.split(' ')[1];

    await localPushService.scheduleNotification(
      id: goal.id,
      title: '아장 아장',
      subtitle: goal.name,
      body:
          '${timeToStr(hour)}:${timeToStr(minute)} $ampm ${'lets_achieve_goal'.tr()}',
      startDate: scheduleStartDate,
      hour: hour,
      minute: minute,
      daysOfWeek: daysOfWeek,
    );
    logger.d(
        'scheduleNotification: ${goal.id} $daysOfWeek $scheduleStartDate $hour:$minute');
  }

  Future<void> sort() async {
    state.sort((a, b) =>
        a.schedule.notificationTime.compareTo(b.schedule.notificationTime));
  }

  String timeToStr(int time) {
    return time.toString().padLeft(2, '0');
  }
}
