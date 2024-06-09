import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';

class GoalGraphWidget extends ConsumerWidget {
  const GoalGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goals = ref.watch(goalsStateProvider);
    var filterTypeState = ref.watch(goalFilterProvider);

    switch (filterTypeState.type) {
      case GoalFilterType.all:
        break;
      case GoalFilterType.active:
        goals = goals.where((element) => element.isEnd == false).toList();
        break;
      case GoalFilterType.completed:
        goals = goals.where((element) => element.isEnd == true).toList();
        break;
    }
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: screenHeight * 0.75,
      child: ListView(
        children: [
          const SizedBox(height: 15),
          Text(
            'achievement_percent'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 400,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 60,
                sections: showingSections(goals),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Goal> goals) {
    var totalAchievements =
        goals.fold<int>(0, (sum, goal) => sum + goal.achievements.length);

    if (totalAchievements == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: '0%',
          radius: 90,
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titlePositionPercentageOffset: 0.6,
        )
      ];
    }

    return List.generate(goals.length, (i) {
      return PieChartSectionData(
        color: goals[i].color,
        value: goals[i].achievements.length.toDouble(),
        title:
            '${goals[i].name}\n(${(goals[i].achievements.length / totalAchievements * 100).round()}%)',
        radius: 90,
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    });
  }
}
