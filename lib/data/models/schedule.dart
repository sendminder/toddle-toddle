import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1)
class Schedule extends HiveObject {
  @HiveField(0)
  final List<int> daysOfWeek;

  @HiveField(1)
  final String notificationTime; // HH:MM

  @HiveField(2)
  final DateTime startDate;

  @HiveField(3)
  final bool isDaily;

  Schedule({
    required this.daysOfWeek,
    required this.notificationTime,
    required this.startDate,
    required this.isDaily,
  });
}
