import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              return focusedContainer(context, now, date);
            },
            defaultBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date);
            },
            outsideBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date);
            },
            disabledBuilder: (context, date, focusedDay) {
              return focusedContainer(context, now, date);
            },
          ),
        ),
      ],
    );
  }

  Container focusedContainer(BuildContext context, DateTime now, DateTime day) {
    bool isAchievement = goal.isAchievement(day);
    // 스케쥴 요일이 맞으면서 && 시작시간 이후이면서 && 내일보다 이전이면서 && 종료시간이 있으면 종료시간보다 이전인경우에만 표시
    var tommorrow =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    bool hasGoalDay = goal.hasGoalDay(day) &&
        day.isAfter(goal.startDate) &&
        day.isBefore(tommorrow);

    if (goal.endTime != null) {
      var endTimeTommorrow =
          DateTime(goal.endTime!.year, goal.endTime!.month, goal.endTime!.day)
              .add(const Duration(days: 1));
      hasGoalDay = hasGoalDay && day.isBefore(endTimeTommorrow);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAchievement ? goal.color : null,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: isAchievement
              ? Colors.white
              : (hasGoalDay ? goal.color : Colors.grey),
        ),
      ),
    );
  }
}
