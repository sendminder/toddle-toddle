import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/add_goal_bottom_sheet.dart';
import 'package:toddle_toddle/widgets/goal_item_builder.dart';

class CheckScreen extends ConsumerWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'title_first',
          textSize: 20,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: const <Widget>[
            GoalItemListWidget(),
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
              );
            },
          );
        },
        tooltip: '항목 추가',
        child: const Icon(FluentIcons.add_24_regular),
      ),
    );
  }
}
