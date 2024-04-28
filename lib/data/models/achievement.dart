import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 2)
class Achievement extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  bool achieved;

  Achievement({required this.date, required this.achieved});

  // 날짜 업데이트 함수
  Future<void> updateDate(DateTime newDate) async {
    date = newDate;
    await save(); // 변경 사항을 Hive에 저장
  }

  // 달성 여부 업데이트 함수
  Future<void> updateAchieved(bool newAchieved) async {
    achieved = newAchieved;
    await save(); // 변경 사항을 Hive에 저장
  }
}
