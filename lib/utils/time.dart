import 'package:flutter/material.dart';

String timeOfDayToString(TimeOfDay timeOfDay) {
  var hour = timeOfDay.hour.toString();
  var minute = timeOfDay.minute.toString();
  if (timeOfDay.hour < 10) {
    hour = '0$hour';
  }
  if (timeOfDay.minute < 10) {
    minute = '0$minute';
  }
  if (timeOfDay.period == DayPeriod.am) {
    return '$hour:$minute AM';
  }
  return '$hour:$minute PM';
}
