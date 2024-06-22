import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/focused_time_state.dart';
import 'package:toddle_toddle/const/style.dart';

class WeeklyCalendar extends ConsumerWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final focusedDay = ref.watch(focusedTimeProvider);
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    var lastDay = now.add(const Duration(days: 7));
    var firstDay = now.add(const Duration(days: -365));
    var backTodayColor = Theme.of(context).colorScheme.primary;
    var isToday = isSameDay(now, focusedDay.focusedTime);

    return Stack(
      children: [
        TableCalendar(
          locale: locale,
          calendarFormat: CalendarFormat.week,
          focusedDay: focusedDay.focusedTime,
          firstDay: firstDay,
          lastDay: lastDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false, // Format 버튼 숨김
            leftChevronVisible: false, // 왼쪽 화살표 숨김
            rightChevronVisible: false, // 오른쪽 화살표 숨김
          ),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(selectedDay, now) && selectedDay.isAfter(now)) {
              showAlertDialog(context, 'select_now_day'.tr());
              return;
            }
            ref.read(focusedTimeProvider.notifier).setFocusedTime(selectedDay);
          },
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              final isFocused = isSameDay(day, focusedDay);
              return focusedContainer(context, now, day, isFocused);
            },
            defaultBuilder: (context, date, _) {
              final isFocused = isSameDay(date, focusedDay.focusedTime);
              return focusedContainer(context, now, date, isFocused);
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
                    ref.read(focusedTimeProvider.notifier).setFocusedTime(now);
                  },
                ),
              ),
      ],
    );
  }

  Container focusedContainer(
      BuildContext context, DateTime now, DateTime day, bool isFocused) {
    if (isSameDay(now, day)) {
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

  void showAlertDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text('check'.tr()),
          content: Text(message, style: contentStyle),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('button_positive'.tr()),
            ),
          ],
        );
      },
    );
  }
}
