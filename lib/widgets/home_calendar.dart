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
        ref.read(focusedDayProvider.notifier).state = selectedDay;
      },
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          final isFocused = isSameDay(day, focusedDay);
          return focusedContainer(day, isFocused);
        },
        defaultBuilder: (context, date, _) {
          final isFocused = isSameDay(date, focusedDay);
          return focusedContainer(date, isFocused);
        },
      ),
    );
  }

  Container focusedContainer(DateTime day, bool isFocused) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFocused ? Colors.purple : null,
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
