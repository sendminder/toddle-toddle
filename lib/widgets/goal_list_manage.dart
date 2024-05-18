import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/add_goal_bottom_sheet.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        var currentGoal = goals[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(currentGoal.schedule.notificationTime),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  currentGoal.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(FluentIcons.chart_multiple_24_regular),
                  onPressed: () {},
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(FluentIcons.edit_settings_24_regular),
                  onPressed: () {
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
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(FluentIcons.delete_24_regular),
                  onPressed: () async {
                    await ref
                        .read(goalsStateProvider.notifier)
                        .removeGoal(currentGoal.id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
