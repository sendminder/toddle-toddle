import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';

class GoalDoneFilterWidget extends ConsumerWidget {
  const GoalDoneFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(goalFilterProvider.notifier).set(false);
          },
          child: const Text('ongoing'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            ref.read(goalFilterProvider.notifier).set(true);
          },
          child: const Text('done'),
        ),
      ],
    );
  }
}
