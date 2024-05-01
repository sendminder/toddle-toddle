import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 2)
class Achievement extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  bool achieved;

  Achievement({required this.date, required this.achieved});

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'achieved': achieved,
    };
  }

  // 날짜 업데이트 함수
  Future<void> updateDate(DateTime newDate) async {
    date = newDate;
  }

  // 달성 여부 업데이트 함수
  Future<void> updateAchieved(bool newAchieved) async {
    achieved = newAchieved;
  }
}
