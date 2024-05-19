import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/widgets/chart/chart_by_day_of_week.dart';
import 'package:toddle_toddle/widgets/chart/goal_achievement_percent.dart';

class GoalChartWidget extends StatelessWidget {
  final Goal goal;

  const GoalChartWidget({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 860,
      child: Column(
        children: [
          Text(
            goal.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GoalAchievementPercentWidget(goal: goal),
          const SizedBox(height: 20),
          ChartByDayOfWeekWidget(goal: goal),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
