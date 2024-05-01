import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:collection/collection.dart';

class GoalItemListWidget extends ConsumerWidget {
  const GoalItemListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);
    DateTime now = DateTime.now();
    DateTime targetTime = DateTime(now.year, now.month, now.day);

    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: goals.isEmpty ? 1 : goals.length,
        itemBuilder: (context, index) {
          if (goals.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'no_goals',
                textSize: 16,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          var currentGoal = goals[index];

          var currentAchievement = currentGoal.achievements
              .where((element) => element.date == targetTime)
              .firstOrNull;

          return ListTile(
            title: Text(goals[index].name),
            subtitle: Text(
              '${goals[index].schedule.notificationTime}',
            ),
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
      ),
    );
  }
}
