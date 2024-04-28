import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 2)
class Achievement extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  bool achieved;

  Achievement({required this.date, required this.achieved});
}
