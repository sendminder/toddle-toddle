import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/widgets/chart/chart_by_day_of_week.dart';
import 'package:toddle_toddle/widgets/chart/goal_achievement_percent.dart';

class GoalChartWidget extends StatelessWidget {
  final Goal goal;

  const GoalChartWidget({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: screenHeight * 0.75,
      child: Column(
        children: [
          Text(
            goal.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GoalAchievementPercentWidget(goal: goal),
          const SizedBox(height: 20),
          ChartByDayOfWeekWidget(goal: goal),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
