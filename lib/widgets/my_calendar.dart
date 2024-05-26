import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final focusedDay = ref.watch(focusedDayProvider);
    final now = DateTime.now();
    var lastDay = now.add(const Duration(days: 7));
    var firstDay = now.add(const Duration(days: -365));
    var backTodayColor = Theme.of(context).colorScheme.primary;
    var isToday = isSameDay(now, focusedDay);

    return Stack(
      children: [
        TableCalendar(
          locale: locale,
          calendarFormat: CalendarFormat.week,
          focusedDay: focusedDay,
          firstDay: firstDay,
          lastDay: lastDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false, // Format 버튼 숨김
            leftChevronVisible: false, // 왼쪽 화살표 숨김
            rightChevronVisible: false, // 오른쪽 화살표 숨김
          ),
          onDaySelected: (selectedDay, focusedDay) {
            var now = DateTime.now();
            if (selectedDay.isAfter(now)) {
              return;
            }
            ref.read(focusedDayProvider.notifier).state = selectedDay;
          },
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              final isFocused = isSameDay(day, focusedDay);
              return focusedContainer(context, day, isFocused);
            },
            defaultBuilder: (context, date, _) {
              final isFocused = isSameDay(date, focusedDay);
              return focusedContainer(context, date, isFocused);
            },
          ),
        ),
        isToday
            ? Container()
            : Positioned(
                left: 80,
                bottom: 63,
                child: IconButton(
                  icon: Icon(
                    FluentIcons.calendar_today_24_regular,
                    color: backTodayColor,
                  ),
                  onPressed: () {
                    ref.read(focusedDayProvider.notifier).state = now;
                  },
                ),
              ),
      ],
    );
  }

  Container focusedContainer(
      BuildContext context, DateTime day, bool isFocused) {
    var now = DateTime.now();
    if (day.isAfter(now)) {
      return Container(
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }
    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      return Container(
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFocused
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withAlpha(100),
        ),
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isFocused ? Colors.white : null,
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFocused ? Theme.of(context).colorScheme.primary : null,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: isFocused ? Colors.white : null,
        ),
      ),
    );
  }
}
