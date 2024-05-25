import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';
import 'package:toddle_toddle/widgets/chart/goal_chart.dart';
import 'package:toddle_toddle/states/theme_mode_state.dart';

class GoalListManageWidget extends ConsumerWidget {
  const GoalListManageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goals = ref.watch(goalsStateProvider);
    var filterTypeState = ref.watch(goalFilterProvider);

    switch (filterTypeState.type) {
      case FilterType.all:
        break;
      case FilterType.active:
        goals = goals.where((element) => element.isEnd == false).toList();
        break;
      case FilterType.completed:
        goals = goals.where((element) => element.isEnd == true).toList();
        break;
    }

    final themeMode = ref.read(themeProvider);
    var alpha = themeMode.themeMode == ThemeMode.dark ? 160 : 190;

    if (goals.isEmpty) {
      return const Center(
        child: CustomText(
          text: 'no_goals',
          textSize: 16,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        var currentGoal = goals[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: currentGoal.isEnd
                  ? currentGoal.color
                  : currentGoal.color.withAlpha(alpha),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    currentGoal.schedule.notificationTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    currentGoal.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.chart_multiple_24_regular,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return GoalChartWidget(goal: currentGoal);
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.edit_settings_24_regular,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return AddOrUpdateGoalBottomSheet(
                            goal: currentGoal,
                            init: false,
                          );
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: currentGoal.isEnd
                        ? const Icon(
                            FluentIcons.arrow_undo_24_filled,
                            color: Colors.white70,
                          )
                        : const Icon(
                            FluentIcons.checkmark_24_filled,
                            color: Colors.white70,
                          ),
                    onPressed: () async {
                      bool? result = currentGoal.isEnd
                          ? await showDeleteConfirmationDialog(
                              context, currentGoal.name, 'recover_goal')
                          : await showDeleteConfirmationDialog(
                              context, currentGoal.name, 'done_goal');
                      if (result == true) {
                        if (currentGoal.isEnd) {
                          await ref
                              .read(goalsStateProvider.notifier)
                              .recoverGoal(currentGoal.id);
                        } else {
                          await ref
                              .read(goalsStateProvider.notifier)
                              .doneGoal(currentGoal.id);
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.delete_24_regular,
                      color: Colors.white70,
                    ),
                    onPressed: () async {
                      bool? result = await showDeleteConfirmationDialog(
                          context, currentGoal.name, 'delete_goal');
                      if (result == true) {
                        await ref
                            .read(goalsStateProvider.notifier)
                            .removeGoal(currentGoal.id);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showDeleteConfirmationDialog(
      BuildContext context, String goalName, String contentNameKey) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
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
}
