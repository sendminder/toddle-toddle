import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/enums/goal_filter_type.dart';
import 'package:toddle_toddle/widgets/chart/goal_achievement_percent.dart';

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

    if (goals.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        height: screenHeight * 0.75,
        child: Center(
          child: Text(
            'no_goals'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // achievement의 true 개수를 기준으로 정렬
    goals.sort((a, b) {
      var aTrueCount =
          a.achievements.where((element) => element.achieved).length;
      var bTrueCount =
          b.achievements.where((element) => element.achieved).length;
      return bTrueCount.compareTo(aTrueCount);
    });

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: screenHeight * 0.75,
      child: ListView(
        children: [
          const SizedBox(height: 15),
          Text(
            'total_achievement_percentage'.tr(),
            style: const TextStyle(
              fontSize: 18,
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
          ...goals.map((goal) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  goal.name,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                GoalAchievementPercentWidget(goal: goal),
              ],
            );
          }),
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
