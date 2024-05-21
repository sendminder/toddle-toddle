import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime? startTime;

  @HiveField(3)
  Schedule schedule;

  @HiveField(4)
  List<Achievement> achievements;

  @HiveField(5)
  Color color;

  @HiveField(6)
  bool? isEnd;

  Goal({
    required this.id,
    required this.name,
    required this.startTime,
    required this.schedule,
    required this.color,
    this.isEnd = false,
    List<Achievement>? achievements,
  }) : achievements = achievements ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime?.toIso8601String(),
      'schedule': schedule.toJson(), // Schedule 클래스에도 toJson() 구현 필요
      'achievements': achievements
          .map((a) => a.toJson())
          .toList(), // Achievement 클래스에도 toJson() 구현 필요
      'color': color.value,
      'isEnd': isEnd,
    };
  }

  static Goal newDefaultGoal() {
    return Goal(
      id: 0,
      name: '',
      startTime: null,
      schedule: Schedule.newDefaultSchedule(),
      color: Colors.blue,
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
}
