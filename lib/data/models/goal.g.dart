// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalRecordAdapter extends TypeAdapter<GoalRecord> {
  @override
  final int typeId = 0;

  @override
  GoalRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalRecord(
      name: fields[0] as String,
      startTime: fields[1] as DateTime,
      schedule: fields[2] as Schedule,
      achievements: (fields[3] as List?)?.cast<Achievement>(),
    );
  }

  @override
  void write(BinaryWriter writer, GoalRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.schedule)
      ..writeByte(3)
      ..write(obj.achievements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
