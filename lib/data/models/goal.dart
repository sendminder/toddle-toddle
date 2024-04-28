import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class GoalRecord extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  Schedule schedule;

  @HiveField(3)
  List<Achievement> achievements;

  GoalRecord({
    required this.name,
    required this.startTime,
    required this.schedule,
    List<Achievement>? achievements,
  }) : this.achievements = achievements ?? [];
}
