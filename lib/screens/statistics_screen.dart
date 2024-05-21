
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/goal/goal_list_manage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/widgets/goal/add_or_update_goal.dart';
import 'package:toddle_toddle/widgets/goal/goal_done_filter.dart';

class StatisticsScreen extends ConsumerWidget {
  StatisticsScreen({super.key}) {
    isEndProvider = StateProvider<bool>((ref) => false);
  }
  late StateProvider<bool> isEndProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'title_second',
          textSize: 20,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            GoalDoneFilterWidget(isEndProvider: isEndProvider),
            GoalListManageWidget(isEndProvider: isEndProvider),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddOrUpdateGoalBottomSheet(
                goal: Goal.newDefaultGoal(),
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
