import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';

class GoalDoneFilterWidget extends ConsumerWidget {
  const GoalDoneFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterTypeState = ref.watch(goalFilterProvider);
    final goals = ref.watch(goalsStateProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final background = Theme.of(context).colorScheme.background;
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
            ref.read(goalFilterProvider.notifier).setFilterType(FilterType.all);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                filterTypeState.type == FilterType.all ? primary : background,
            foregroundColor:
                filterTypeState.type == FilterType.all ? background : primary,
            minimumSize: minSize,
          ),
          child: Text('${'all'.tr()}($allCount)',
              style: filterTypeState.type == FilterType.all
                  ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            ref
                .read(goalFilterProvider.notifier)
                .setFilterType(FilterType.active);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: filterTypeState.type == FilterType.active
                ? primary
                : background,
            foregroundColor: filterTypeState.type == FilterType.active
                ? background
                : primary,
            minimumSize: minSize,
          ),
          child: Text('${'active'.tr()}($activeCount)',
              style: filterTypeState.type == FilterType.active
                  ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            ref
                .read(goalFilterProvider.notifier)
                .setFilterType(FilterType.completed);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: filterTypeState.type == FilterType.completed
                ? primary
                : background,
            foregroundColor: filterTypeState.type == FilterType.completed
                ? background
                : primary,
            minimumSize: minSize,
          ),
          child: Text('${'completed'.tr()}($completedCount)',
              style: filterTypeState.type == FilterType.completed
                  ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }
}
