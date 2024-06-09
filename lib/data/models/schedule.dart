import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/enums/schedule_type.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1)
class Schedule extends HiveObject {
  @HiveField(0)
  List<int> daysOfWeek;

  @HiveField(1)
  String notificationTime; // HH:MM AM

  @HiveField(2)
  ScheduleType scheduleType;

  Schedule({
    required this.daysOfWeek,
    required this.notificationTime,
    required this.scheduleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'daysOfWeek': daysOfWeek,
      'notificationTime': notificationTime,
      'scheduleType': scheduleType,
    };
  }

  static newDefaultSchedule() {
    return Schedule(
      daysOfWeek: [],
      notificationTime: '09:30 AM',
      scheduleType: ScheduleType.daily,
    );
  }

  // daysOfWeek 수정 함수
  Future<void> updateDaysOfWeek(List<int> newDaysOfWeek) async {
    daysOfWeek = newDaysOfWeek;
    await save(); // Hive에 변경사항 저장
  }

  // notificationTime 수정 함수
  Future<void> updateNotificationTime(String newNotificationTime) async {
    notificationTime = newNotificationTime;
    await save(); // Hive에 변경사항 저장
  }

  Future<void> updateScheduleType(ScheduleType type) async {
    scheduleType = type;
    await save(); // Hive에 변경사항 저장
  }

  int notificationTimeHour() {
    return int.parse(notificationTime.split(':')[0]);
  }

  int notificationTimeMinute() {
    return int.parse(notificationTime.split(':')[1].split(' ')[0]);
  }

  String notificationTimeAmPm() {
    return notificationTime.split(' ')[1];
  }
}
