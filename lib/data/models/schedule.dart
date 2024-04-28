import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1)
class Schedule extends HiveObject {
  @HiveField(0)
  List<int> daysOfWeek;

  @HiveField(1)
  String notificationTime; // HH:MM

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  bool isDaily;

  Schedule({
    required this.daysOfWeek,
    required this.notificationTime,
    required this.startDate,
    required this.isDaily,
  });

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

  // startDate 수정 함수
  Future<void> updateStartDate(DateTime newStartDate) async {
    startDate = newStartDate;
    await save(); // Hive에 변경사항 저장
  }
}
