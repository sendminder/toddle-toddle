import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/states/focused_time_state.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';
import 'package:toddle_toddle/widgets/goal/goal_item_builder.dart';
import 'package:toddle_toddle/widgets/calendar/weekly_calendar.dart';

class CheckScreen extends ConsumerWidget {
  const CheckScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Offset initialSwipeOffset = Offset.zero;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onPanStart: (details) => initialSwipeOffset = details.localPosition,
        onPanEnd: (details) {
          final dx = details.velocity.pixelsPerSecond.dx;
          if (dx > 0) {
            ref.read(focusedTimeProvider.notifier).dayCountDown();
          } else if (dx < 0) {
            ref.read(focusedTimeProvider.notifier).dayCountUp();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 15),
                const WeeklyCalendar(),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: const <Widget>[
                      GoalItemListWidget(),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            builder: (BuildContext context) {
              return AddOrUpdateGoalBottomSheet(
                initGoal: Goal.newDefaultGoal(),
                init: true,
              );
            },
          );
        },
        tooltip: 'add_goal'.tr(),
        child: const Icon(FluentIcons.add_24_regular),
      ),
    );
  }
}
