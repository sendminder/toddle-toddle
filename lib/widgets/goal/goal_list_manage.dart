import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';
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
    var alpha = themeMode.themeMode == ThemeMode.dark ? 145 : 180;

    if (goals.isEmpty) {
      if (filterTypeState.type == FilterType.completed) {
        return Center(
          child: Text(
            'no_completed_goals'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }
      return Center(
        child: Text(
          'no_goals'.tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        var currentGoal = goals[index];
        var goalNameColor = currentGoal.isEnd ? Colors.white70 : Colors.white;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: currentGoal.isEnd
                  ? currentGoal.color.withAlpha(alpha)
                  : currentGoal.color,
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
                  child: GestureDetector(
                    onTap: () async {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        showDragHandle: true,
                        context: context,
                        builder: (BuildContext context) {
                          return GoalChartWidget(goal: currentGoal);
                        },
                      );
                    },
                    child: Text(
                      currentGoal.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: goalNameColor,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.white70,
                        decoration: currentGoal.isEnd
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
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
                              // ignore: use_build_context_synchronously
                              context,
                              currentGoal.name,
                              'recover_goal')
                          : await showDeleteConfirmationDialog(
                              // ignore: use_build_context_synchronously
                              context,
                              currentGoal.name,
                              'done_goal');
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
                const SizedBox(width: 10),
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
                const SizedBox(width: 5),
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
