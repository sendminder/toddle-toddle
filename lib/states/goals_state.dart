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
  GoalsState.createSorted().then((initializedState) {
    ref.read(goalsStateProvider.notifier).state = initializedState.state;
  });
  return state;
});

class GoalsState extends StateNotifier<List<Goal>> {
  final logger = GetIt.I<Logger>();
  final localPushService = GetIt.I<LocalPushService>();
  final int syncInterval = 0; //60 * 60 * 6;

  GoalsState() : super([]) {}

  static Future<GoalsState> createSorted() async {
    var state = GoalsState();
    await state._initialize();
    state.sort();
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
    final box = await Hive.openBox<Goal>(HiveGoalBox);
    state = box.values.toList();

    final int scheduleSyncTime =
        await Hive.box(HivePrefBox).get('scheduleSyncTime', defaultValue: 0);
    int nowSecond = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (scheduleSyncTime == 0 || scheduleSyncTime + syncInterval < nowSecond) {
      syncSchedule();
      await Hive.box(HivePrefBox).put('scheduleSyncTime', 0);
    }
  }

  bool isExist(int id) {
    final box = Hive.box<Goal>(HiveGoalBox);
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
    final box = Hive.box<Goal>(HiveGoalBox);
    if (isExist(goal.id)) {
      // Goal이 이미 존재하면 업데이트
      await box.put(goal.id, goal);
      state = state.map((g) => g.id == goal.id ? goal : g).toList();
    } else {
      // Goal이 존재하지 않으면 추가
      await box.put(goal.id, goal);
      state = [...state, goal];
    }
    updatePushSchedule(goal.id);
    sort();
  }

  // 특정 Goal 삭제
  Future<void> removeGoal(int id) async {
    final box = Hive.box<Goal>(HiveGoalBox);
    await box.delete(id); // ID를 사용하여 삭제
    state = state.where((goal) => goal.id != id).toList(); // 상태 갱신
  }

  // 특정 Goal id의 Achievement를 수정하거나 추가하는 함수
  Future<void> addOrUpdateAchievement(
      int goalId, DateTime date, bool achieved) async {
    final box = Hive.box<Goal>(HiveGoalBox);
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

  // 특정 Goal id의 Schedule을 수정하는 함수
  Future<void> updateSchedule(int goalId, List<int> daysOfWeek,
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

  void syncSchedule() async {
    localPushService.cancelAll();
    for (int i = 0; i < state.length; i++) {
      var goal = state[i];
      _updatePushSchedule(goal, false);
    }
  }

  void updatePushSchedule(int goalId) {
    var goal = getGoalById(goalId);
    if (goal != null) _updatePushSchedule(goal, true);
  }

  void _updatePushSchedule(Goal goal, bool needCancle) {
    var daysOfWeek = goal.schedule.daysOfWeek;
    if (goal.schedule.isDaily) {
      daysOfWeek = [0, 1, 2, 3, 4, 5, 6];
    }
    if (needCancle) {
      for (int j = 0; j < 7; j++) {
        localPushService.cancelNotification(goal.id + j);
        logger.d('cancelNotification: ${goal.id + j}');
      }
    }

    // 시작 시간이
    // null 이거나 현재보다 이전이면 현재날로 설정
    // 현재보다 미래이면 시작 시간으로 설정
    var scheduleStartDate = DateTime.now();
    if (goal.startTime != null && scheduleStartDate.isBefore(goal.startTime!)) {
      scheduleStartDate = goal.startTime!;
    }

    localPushService.scheduleNotification(
      id: goal.id,
      title: '목표 알림',
      body: goal.name,
      startDate: scheduleStartDate,
      hour: goal.schedule.notificationTimeHour(),
      minute: goal.schedule.notificationTimeMinute(),
      daysOfWeek: daysOfWeek,
    );
    logger.d('scheduleNotification: ${goal.id} $daysOfWeek' +
        ' ${goal.schedule.notificationTimeHour()}:${goal.schedule.notificationTimeMinute()}');
  }

  void sort() {
    state.sort((a, b) =>
        a.schedule.notificationTime.compareTo(b.schedule.notificationTime));
  }
}
