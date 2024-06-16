import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/widgets/goal/goal_list_manage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';
import 'package:toddle_toddle/widgets/goal/goal_done_filter.dart';
import 'package:toddle_toddle/widgets/chart/goal_graph.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Offset initialSwipeOffset = Offset.zero;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onPanStart: (details) => initialSwipeOffset = details.localPosition,
        onPanEnd: (details) {
          final dx = details.velocity.pixelsPerSecond.dx;
          if (dx > 0) {
            var currentType = ref.read(goalFilterProvider.notifier).filterType;
            currentType = currentType.getLeftFilterType();
            ref.read(goalFilterProvider.notifier).setFilterType(currentType);
          } else if (dx < 0) {
            var currentType = ref.read(goalFilterProvider.notifier).filterType;
            currentType = currentType.getRightFilterType();
            ref.read(goalFilterProvider.notifier).setFilterType(currentType);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                Stack(
                  children: <Widget>[
                    const Center(
                      child: GoalDoneFilterWidget(),
                    ),
                    Positioned(
                      right: 12,
                      child: IconButton(
                        icon: Icon(
                          FluentIcons.chart_multiple_24_regular,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            showDragHandle: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const GoalGraphWidget();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView(
                    children: const <Widget>[
                      GoalListManageWidget(),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            builder: (BuildContext context) {
              return AddOrUpdateGoalBottomSheet(
                initGoal: Goal.newDefaultGoal(),
                init: true,
              );
            },
          );
        },
        tooltip: 'add_goal'.tr(),
        child: const Icon(FluentIcons.add_24_regular),
      ),
    );
  }
}
