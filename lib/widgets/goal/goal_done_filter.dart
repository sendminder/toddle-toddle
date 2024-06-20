import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';

class GoalDoneFilterWidget extends ConsumerWidget {
  const GoalDoneFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterTypeState = ref.watch(goalFilterProvider);
    final goals = ref.watch(goalsStateProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final background = Theme.of(context).colorScheme.surface;
    final selectedColor = Colors.white.withAlpha(200);
    const minSize = Size(40, 35);

    final allCount = goals.length;
    final activeCount = goals.where((element) => element.isEnd == false).length;
    final completedCount =
        goals.where((element) => element.isEnd == true).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            ref
                .read(goalFilterProvider.notifier)
                .setFilterType(GoalFilterType.all);
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: filterTypeState.type == GoalFilterType.all
                ? primary
                : background,
            foregroundColor: filterTypeState.type == GoalFilterType.all
                ? selectedColor
                : primary,
            minimumSize: minSize,
          ),
          child: Text('${'all'.tr()}($allCount)',
              style: filterTypeState.type == GoalFilterType.all
                  ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            ref
                .read(goalFilterProvider.notifier)
                .setFilterType(GoalFilterType.active);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: filterTypeState.type == GoalFilterType.active
                ? primary
                : background,
            foregroundColor: filterTypeState.type == GoalFilterType.active
                ? selectedColor
                : primary,
            minimumSize: minSize,
          ),
          child: Text('${'active'.tr()}($activeCount)',
              style: filterTypeState.type == GoalFilterType.active
                  ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            ref
                .read(goalFilterProvider.notifier)
                .setFilterType(GoalFilterType.completed);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: filterTypeState.type == GoalFilterType.completed
                ? primary
                : background,
            foregroundColor: filterTypeState.type == GoalFilterType.completed
                ? selectedColor
                : primary,
            minimumSize: minSize,
          ),
          child: Text('${'completed'.tr()}($completedCount)',
              style: filterTypeState.type == GoalFilterType.completed
                  ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }
}
