import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:collection/collection.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime? startTime;

  @HiveField(3)
  Schedule schedule;

  @HiveField(4)
  List<Achievement> achievements;

  Goal({
    required this.id,
    required this.name,
    required this.startTime,
    required this.schedule,
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
    };
  }

  static Goal newDefaultGoal() {
    return Goal(
      id: '',
      name: '',
      startTime: null,
      schedule: Schedule.newDefaultSchedule(),
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
}
