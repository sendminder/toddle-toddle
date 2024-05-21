import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalDoneFilterWidget extends ConsumerWidget {
  GoalDoneFilterWidget({super.key, required this.isEndProvider});
  late StateProvider<bool> isEndProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(isEndProvider.notifier).state = false;
          },
          child: const Text('ongoing'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            ref.read(isEndProvider.notifier).state = true;
          },
          child: const Text('done'),
        ),
      ],
    );
  }
}
