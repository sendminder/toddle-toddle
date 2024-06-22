import 'dart:math';

import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/utils/color_palette.dart';
import 'package:toddle_toddle/data/enums/schedule_type.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  Schedule schedule;

  @HiveField(5)
  List<Achievement> achievements;

  @HiveField(6)
  Color color;

  @HiveField(7)
  bool isEnd;

  @HiveField(8)
  bool needPush;

  @HiveField(9)
  int targetAchievementCount;

  Goal({
    required this.id,
    required this.name,
    required this.startDate,
    required this.schedule,
    required this.color,
    this.isEnd = false,
    this.needPush = true,
    List<Achievement>? achievements,
    DateTime? endTime,
    this.targetAchievementCount = 1,
  }) : achievements = achievements ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'schedule': schedule.toJson(), // Schedule 클래스에도 toJson() 구현 필요
      'achievements': achievements
          .map((a) => a.toJson())
          .toList(), // Achievement 클래스에도 toJson() 구현 필요
      'color': color.value,
      'isEnd': isEnd,
      'needPush': needPush,
      'targetAchievementCount': targetAchievementCount,
    };
  }

  static Goal newDefaultGoal() {
    final randome = Random().nextInt(palette.length - 1);
    final now = DateTime.now();
    return Goal(
      id: 0,
      name: '',
      startDate: DateTime(now.year, now.month, now.day),
      schedule: Schedule.newDefaultSchedule(),
      color: palette[randome],
    );
  }

  // 특정 날짜에 해당하는 Achievement 찾기
  Achievement? findAchievementByDate(DateTime date) {
    return achievements
        .firstWhereOrNull((achievement) => achievement.date == date);
  }

  // Achievement 추가
  Future<void> addAchievement(Achievement achievement) async {
    achievements.add(achievement);
  }

  void deleteAchievement(DateTime date) async {
    achievements.removeWhere((achievement) => achievement.date == date);
  }

  GoalStatistics getGoalStatistics() {
    int totalAchievementsCount =
        achievements.where((a) => a.achievedCount >= 1).length;

    var lastDay = DateTime.now();
    if (endTime != null) {
      lastDay = endTime!;
    }
    int totalDays = lastDay.difference(startDate).inDays + 1;

    // 주별 스케쥴은 다르게 계산해야 함
    if (schedule.scheduleType == ScheduleType.weekly) {
      totalDays = 0;
      var currentDay = startDate;
      if (endTime != null) {
        lastDay = DateTime(endTime!.year, endTime!.month, endTime!.day)
            .add(const Duration(days: 1));
      }
      while (currentDay.isBefore(lastDay) ||
          currentDay.isAtSameMomentAs(lastDay)) {
        if (schedule.daysOfWeek.contains(currentDay.weekday - 1)) {
          totalDays++;
        }
        currentDay = currentDay.add(const Duration(days: 1));
      }
    } else if (schedule.scheduleType == ScheduleType.once) {
      totalDays = 1;
    }

    double achievementPercentage =
        (totalAchievementsCount / (totalDays * targetAchievementCount)) * 100;
    return GoalStatistics(
      achievementPercentage: achievementPercentage,
      totalAchievements: totalAchievementsCount,
      totalDays: totalDays,
    );
  }

  Goal copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endTime,
    Schedule? schedule,
    List<Achievement>? achievements,
    Color? color,
    bool? isEnd,
    bool? needPush,
    int? targetAchievementCount,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endTime: endTime ?? this.endTime,
      schedule: schedule ?? this.schedule,
      achievements: achievements ?? this.achievements,
      color: color ?? this.color,
      isEnd: isEnd ?? this.isEnd,
      needPush: needPush ?? this.needPush,
      targetAchievementCount:
          targetAchievementCount ?? this.targetAchievementCount,
    );
  }

  bool isGoalPlanned(DateTime day) {
    bool isGoalPlanned = false;

    // 스케쥴 요일이 맞으면서
    ScheduleType scheduleType = schedule.scheduleType;
    switch (scheduleType) {
      case ScheduleType.daily:
        isGoalPlanned = true;
        break;
      case ScheduleType.once:
        isGoalPlanned = isSameDay(startDate, day);
        break;
      case ScheduleType.weekly:
        isGoalPlanned = schedule.daysOfWeek.contains(day.weekday - 1);
        break;
      default:
        break;
    }

    // && 시작시간 이후이면서 && 내일보다 이전이면서
    var tommorrow = nextDay(DateTime.now());
    isGoalPlanned =
        isGoalPlanned && day.isAfter(startDate) && day.isBefore(tommorrow);

    // && 종료시간이 있으면 종료시간보다 이전인경우에만 표시
    if (endTime != null) {
      var endTimeTommorrow = nextDay(endTime!);
      isGoalPlanned = isGoalPlanned && day.isBefore(endTimeTommorrow);
    }

    return isGoalPlanned;
  }

  bool isAchievement(DateTime day) {
    Achievement? achievement =
        achievements.where((a) => isSameDay(a.date, day)).firstOrNull;
    if (achievement == null) {
      return false;
    }
    return achievement.achieved &&
        targetAchievementCount <= achievement.achievedCount;
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime nextDay(DateTime current) {
    return DateTime(current.year, current.month, current.day)
        .add(const Duration(days: 1));
  }
}

class GoalStatistics {
  final int totalAchievements;
  final int totalDays;
  final double achievementPercentage;

  GoalStatistics(
      {required this.totalAchievements,
      required this.totalDays,
      required this.achievementPercentage});
}
