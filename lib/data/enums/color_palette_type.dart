enum ColorPaletteType {
  yellow,
  purple,
  green,
}

extension ColorPaletteTypeExtension on ColorPaletteType {
  String toStringValue() {
    switch (this) {
      case ColorPaletteType.yellow:
        return 'yellow';
      case ColorPaletteType.purple:
        return 'purple';
      case ColorPaletteType.green:
        return 'green';
    }
  }
}
