import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/data/enums/schedule_type.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:toddle_toddle/data/models/goal.dart';

class MonthlyCalendar extends ConsumerWidget {
  const MonthlyCalendar({super.key, required this.goal});

  final Goal goal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    var lastDay = now.add(const Duration(days: 7));
    var firstDay = now.add(const Duration(days: -365));

    return Stack(
      children: [
        TableCalendar(
          locale: locale,
          calendarFormat: CalendarFormat.month,
          focusedDay: now,
          firstDay: firstDay,
          lastDay: lastDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false, // Format 버튼 숨김
            leftChevronVisible: false, // 왼쪽 화살표 숨김
            rightChevronVisible: false, // 오른쪽 화살표 숨김
          ),
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date, false);
            },
            defaultBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date, false);
            },
            outsideBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date, true);
            },
            disabledBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date, true);
            },
          ),
        ),
      ],
    );
  }

  Container focusedContainer(
      BuildContext context, DateTime now, DateTime day, bool isOutRange) {
    bool isAchievement = goal.isAchievement(day);
    bool hasGoalDay = goal.hasGoalDay(day);

    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAchievement && !isOutRange ? goal.color : null,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: isAchievement
              ? Colors.white
              : (hasGoalDay && !isOutRange ? goal.color : Colors.grey),
        ),
      ),
    );
  }
}