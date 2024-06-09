enum ScheduleType {
  once,
  daily,
  weekly,
  monthly,
}

extension ScheduleTypeExtension on ScheduleType {
  int toIntValue() {
    switch (this) {
      case ScheduleType.once:
        return 0;
      case ScheduleType.daily:
        return 1;
      case ScheduleType.weekly:
        return 2;
      case ScheduleType.monthly:
        return 3;
    }
  }

  static ScheduleType fromIntValue(int value) {
    switch (value) {
      case 0:
        return ScheduleType.once;
      case 1:
        return ScheduleType.daily;
      case 2:
        return ScheduleType.weekly;
      case 3:
        return ScheduleType.monthly;
      default:
        throw ArgumentError("Invalid integer value for ScheduleType: $value");
    }
  }
}
