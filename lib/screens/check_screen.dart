import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/add_goal_bottom_sheet.dart';

class CheckScreen extends ConsumerWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);

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
            return ListTile(
              title: Text(goals[index].name),
              subtitle: Text(
                goals[index].startTime.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddGoalBottomSheet();
            },
          );
        },
        tooltip: '항목 추가',
        child: const Icon(FluentIcons.add_24_regular),
      ),
    );
  }
}
