import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';

class GoalFilterTypeAdapter extends TypeAdapter<GoalFilterType> {
  @override
  final typeId = 100; // Unique identifier for the adapter

  @override
  GoalFilterType read(BinaryReader reader) {
    final index = reader.readByte();
    return GoalFilterType.values[index];
  }

  @override
  void write(BinaryWriter writer, GoalFilterType obj) {
    writer.writeByte(obj.index);
  }
}
