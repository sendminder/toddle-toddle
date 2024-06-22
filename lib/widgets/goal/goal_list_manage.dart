import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/chart/goal_chart.dart';
import 'package:toddle_toddle/states/theme_mode_state.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toddle_toddle/const/style.dart';

class GoalListManageWidget extends ConsumerWidget {
  const GoalListManageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goals = ref.watch(goalsStateProvider);
    var filterTypeState = ref.watch(goalFilterProvider);

    switch (filterTypeState.type) {
      case GoalFilterType.all:
        break;
      case GoalFilterType.active:
        goals = goals.where((element) => element.isEnd == false).toList();
        break;
      case GoalFilterType.completed:
        goals = goals.where((element) => element.isEnd == true).toList();
        break;
    }

    final themeMode = ref.read(themeProvider);
    var alpha = themeMode.themeMode == ThemeMode.dark ? 145 : 180;

    if (goals.isEmpty) {
      if (filterTypeState.type == GoalFilterType.completed) {
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
        final currentGoal = goals[index];
        var goalNameColor = currentGoal.isEnd ? Colors.white70 : Colors.white;
        GoalStatistics goalStat = currentGoal.getGoalStatistics();

        return Slidable(
          key: Key(currentGoal.id.toString()),
          closeOnScroll: true,
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                autoClose: true,
                onPressed: (context) async {
                  bool? result = await showDeleteConfirmationDialog(
                      context, currentGoal.name, 'delete_goal');
                  if (result == true) {
                    await ref
                        .read(goalsStateProvider.notifier)
                        .removeGoal(currentGoal.id);
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: currentGoal.color,
                icon: Icon(
                  FluentIcons.delete_24_regular,
                  color: currentGoal.color,
                ).icon,
                label: 'delete'.tr(),
                spacing: 4,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    currentGoal.color, // 시작 색상
                    currentGoal.color,
                    currentGoal.color.withAlpha(alpha),
                  ],
                  stops: [
                    0.0, // 시작 지점
                    goalStat.achievementPercentage / 100,
                    goalStat.achievementPercentage / 100,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
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
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      padding: const EdgeInsets.only(right: 2),
                      icon: const Icon(
                        FluentIcons.edit_settings_24_regular,
                        color: Colors.white70,
                      ),
                      onPressed: () {
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
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      padding: const EdgeInsets.only(right: 2),
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
                  const SizedBox(width: 5),
                ],
              ),
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(goalName),
          content: Text(contentNameKey.tr(), style: contentStyle),
          actions: <Widget>[
            TextButton(
              child: Text('button_negative'.tr(), style: contentStyle),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('button_positive'.tr(), style: contentStyle),
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
