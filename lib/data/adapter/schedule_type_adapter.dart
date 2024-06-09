import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/enums/schedule_type.dart';

class ScheduleTypeAdapter extends TypeAdapter<ScheduleType> {
  @override
  final typeId = 102; // Unique identifier for the adapter

  @override
  ScheduleType read(BinaryReader reader) {
    final index = reader.readByte();
    return ScheduleType.values[index];
  }

  @override
  void write(BinaryWriter writer, ScheduleType obj) {
    writer.writeByte(obj.index);
  }
}
