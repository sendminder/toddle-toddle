import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startTime;

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
  }) : this.achievements = achievements ?? [];
}
