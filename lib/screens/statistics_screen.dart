import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/widgets/goal_list_manage.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

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
          children: const <Widget>[
            GoalListManageWidget(),
          ],
        ),
      ),
    );
  }
}
