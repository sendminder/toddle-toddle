import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:collection/collection.dart';
import 'package:toddle_toddle/widgets/add_goal_bottom_sheet.dart';
import 'package:toddle_toddle/widgets/home_calendar.dart';

class GoalItemListWidget extends ConsumerWidget {
  const GoalItemListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);
    final focusTime = ref.watch(focusedDayProvider);
    final targetTime = DateTime(focusTime.year, focusTime.month, focusTime.day);

    bool hasContents = false;
    for (var goal in goals) {
      if (hasThatTimeSchedule(targetTime, goal)) {
        hasContents = true;
        break;
      }
    }

    if (goals.isEmpty || !hasContents) {
      return const Center(
        child: CustomText(
          text: 'no_goals',
          textSize: 16,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.isEmpty ? 1 : goals.length,
      itemBuilder: (context, index) {
        var currentGoal = goals[index];

        if (hasThatTimeSchedule(targetTime, currentGoal) == false) {
          return const SizedBox.shrink();
        }

        var currentAchievement = currentGoal.achievements
            .where((element) => element.date == targetTime)
            .firstOrNull;

        return ListTile(
          title: Text(currentGoal.name),
          subtitle: Text(
            currentGoal.schedule.notificationTime,
          ),
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return AddOrUpdateGoalBottomSheet(
                  goal: currentGoal,
                );
              },
            );
          },
          trailing: Wrap(
            spacing: 12, // space between two icons
            children: <Widget>[
              Checkbox(
                value: currentAchievement?.achieved ?? false,
                onChanged: (bool? value) async {
                  await ref
                      .read(goalsStateProvider.notifier)
                      .addOrUpdateAchievement(
                          currentGoal.id, targetTime, value!);
                },
              ),
              IconButton(
                icon: const Icon(FluentIcons.delete_24_regular),
                onPressed: () async {
                  await ref
                      .read(goalsStateProvider.notifier)
                      .removeGoal(currentGoal.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 시작 시간이 설정되어 있고, 현재 시간보다 미래인 경우 스킵
  // 또는 주간 목표인 경우, 오늘 요일이 설정되어 있지 않은 경우 스킵
  bool hasThatTimeSchedule(DateTime targetTime, Goal goal) {
    if (goal.schedule.isDaily) {
      if (goal.startTime == null) {
        return true;
      }
      if (goal.startTime!.isBefore(targetTime) ||
          goal.startTime!.isAtSameMomentAs(targetTime)) {
        return true;
      }
    }

    if (goal.schedule.isDaily == false && goal.startTime != null) {
      if (goal.startTime!.isAfter(targetTime)) {
        return false;
      }
    }

    if (goal.schedule.daysOfWeek.contains(targetTime.weekday - 1)) {
      return true;
    }

    return false;
  }
}
