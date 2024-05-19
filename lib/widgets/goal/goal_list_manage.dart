import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';
import 'package:toddle_toddle/widgets/chart/goal_chart.dart';

class GoalListManageWidget extends ConsumerWidget {
  const GoalListManageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);

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
              color: currentGoal.color.withAlpha(150),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
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
                  flex: 5,
                  child: Text(
                    currentGoal.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(
                      FluentIcons.chart_multiple_24_regular,
                      color: currentGoal.color,
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
                    icon: Icon(
                      FluentIcons.edit_settings_24_regular,
                      color: currentGoal.color,
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
                    icon: Icon(
                      FluentIcons.delete_24_regular,
                      color: currentGoal.color,
                    ),
                    onPressed: () async {
                      bool? result = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(currentGoal.name),
                            content: Text('delete_goal'.tr()),
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
}
