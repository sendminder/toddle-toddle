import 'package:hive/hive.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';

class FilterTypeAdapter extends TypeAdapter<FilterType> {
  @override
  final typeId = 100; // Unique identifier for the adapter

  @override
  FilterType read(BinaryReader reader) {
    final index = reader.readByte();
    return FilterType.values[index];
  }

  @override
  void write(BinaryWriter writer, FilterType obj) {
    writer.writeByte(obj.index);
  }
}
