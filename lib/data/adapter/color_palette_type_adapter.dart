import 'package:hive/hive.dart';
import 'package:toddle_toddle/data/enums/color_palette_type.dart';

class ColorPaletteTypeAdapter extends TypeAdapter<ColorPaletteType> {
  @override
  final typeId = 101; // Unique identifier for the adapter

  @override
  ColorPaletteType read(BinaryReader reader) {
    final index = reader.readByte();
    return ColorPaletteType.values[index];
  }

  @override
  void write(BinaryWriter writer, ColorPaletteType obj) {
    writer.writeByte(obj.index);
  }
}
