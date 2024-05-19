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

String timeToYearMonthDay(DateTime time) {
  var year = time.year.toString();
  var month = time.month.toString();
  var day = time.day.toString();
  if (time.month < 10) {
    month = '0$month';
  }
  if (time.day < 10) {
    day = '0$day';
  }
  return '$year-$month-$day';
}
