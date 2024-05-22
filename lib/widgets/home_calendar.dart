import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final focusedDay = ref.watch(focusedDayProvider);

    return TableCalendar(
      locale: locale,
      calendarFormat: CalendarFormat.week,
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
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
