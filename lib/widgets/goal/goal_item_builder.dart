import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/data/models/achievement.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:collection/collection.dart';
import 'package:toddle_toddle/widgets/calendar/weekly_calendar.dart';
import 'package:toddle_toddle/states/theme_mode_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/data/enums/schedule_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';

class GoalItemListWidget extends ConsumerWidget {
  const GoalItemListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);
    final focusTime = ref.watch(focusedDayProvider);
    final targetTime = DateTime(focusTime.year, focusTime.month, focusTime.day);

    bool hasContents = false;
    for (var goal in goals) {
      if (hasThatTimeSchedule(targetTime, goal) && !goal.isEnd) {
        hasContents = true;
        break;
      }
    }

    if (goals.isEmpty || !hasContents) {
      return Center(
        child: Text(
          'no_goals'.tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    final themeMode = ref.read(themeProvider);
    var inActiveAlpha = themeMode.themeMode == ThemeMode.dark ? 145 : 180;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        var currentGoal = goals[index];

        if (!hasThatTimeSchedule(targetTime, currentGoal) ||
            currentGoal.isEnd) {
          return const SizedBox.shrink();
        }

        var currentAchievement = currentGoal.achievements
            .where((element) => element.date == targetTime)
            .firstOrNull;

        var done = currentAchievement?.achieved ?? false;
        var alpha = done ? inActiveAlpha : 255;
        var goalNameColor = done ? Colors.white70 : Colors.white;

        return Slidable(
          key: Key(currentGoal.id.toString()),
          closeOnScroll: true,
          endActionPane: ActionPane(
            extentRatio: 0.23,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                autoClose: true,
                onPressed: (context) async {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    showDragHandle: true,
                    context: context,
                    builder: (BuildContext context) {
                      return AddOrUpdateGoalBottomSheet(
                        initGoal: currentGoal,
                        init: false,
                      );
                    },
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: currentGoal.color,
                icon: Icon(
                  FluentIcons.edit_settings_24_regular,
                  color: currentGoal.color,
                ).icon,
                label: 'edit'.tr(),
                spacing: 4,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              decoration: BoxDecoration(
                color: currentGoal.color.withAlpha(alpha),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () async {
                        await updateAchievement(context, ref,
                            currentAchievement, currentGoal, targetTime);
                      },
                      child: Text(
                        currentGoal.schedule.notificationTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: GestureDetector(
                      onTap: () async {
                        await updateAchievement(context, ref,
                            currentAchievement, currentGoal, targetTime);
                      },
                      child: Text(
                        currentGoal.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: goalNameColor,
                          fontWeight: FontWeight.bold,
                          decorationColor: Colors.white70,
                          decoration: done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: currentGoal.needPush
                          ? const Icon(
                              FluentIcons.alert_24_filled,
                              color: Colors.white70,
                            )
                          : const Icon(FluentIcons.alert_off_24_filled,
                              color: Colors.white70),
                      onPressed: () {
                        ref
                            .read(goalsStateProvider.notifier)
                            .toggleNeedPush(currentGoal.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        fillColor: WidgetStateProperty.all(
                            currentGoal.color.withAlpha(170)),
                        value: currentAchievement?.achieved ?? false,
                        onChanged: (bool? value) async {
                          await updateAchievement(context, ref,
                              currentAchievement, currentGoal, targetTime);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> updateAchievement(
    BuildContext context,
    WidgetRef ref,
    Achievement? currentAchievement,
    Goal currentGoal,
    DateTime targetTime,
  ) async {
    bool newValue = !(currentAchievement?.achieved ?? false);
    if (currentGoal.schedule.scheduleType == ScheduleType.once && newValue) {
      var res = await showConfirmationDialog(
          context, currentGoal.name, "complete_goal");
      if (res == true) {
        ref
            .read(goalsStateProvider.notifier)
            .addOrUpdateAchievement(currentGoal.id, targetTime, newValue);

        ref.read(goalsStateProvider.notifier).doneGoal(currentGoal.id);
      }
    } else {
      ref
          .read(goalsStateProvider.notifier)
          .addOrUpdateAchievement(currentGoal.id, targetTime, newValue);
    }
  }

  Future<bool?> showConfirmationDialog(
      BuildContext context, String goalName, String contentNameKey) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(goalName),
          content: Text(contentNameKey.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('button_negative'.tr()),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('button_positive'.tr()),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  // 시작 시간이 설정되어 있고, 현재 시간보다 미래인 경우 스킵
  // 또는 주간 목표인 경우, 오늘 요일이 설정되어 있지 않은 경우 스킵
  bool hasThatTimeSchedule(DateTime targetTime, Goal goal) {
    if (goal.schedule.scheduleType == ScheduleType.daily) {
      if (goal.startDate.isBefore(targetTime) ||
          goal.startDate.isAtSameMomentAs(targetTime)) {
        return true;
      }
    }

    if (goal.schedule.scheduleType == ScheduleType.weekly) {
      if (goal.startDate.isAfter(targetTime)) {
        return false;
      }
      if (goal.schedule.daysOfWeek.contains(targetTime.weekday - 1)) {
        return true;
      }
    }

    if (goal.schedule.scheduleType == ScheduleType.once) {
      if (goal.startDate.year == targetTime.year &&
          goal.startDate.month == targetTime.month &&
          goal.startDate.day == targetTime.day) {
        return true;
      }
    }

    return false;
  }
}
