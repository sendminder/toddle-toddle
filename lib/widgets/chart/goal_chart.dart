import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/widgets/chart/chart_by_day_of_week.dart';
import 'package:toddle_toddle/widgets/chart/goal_achievement_percent.dart';
import 'package:toddle_toddle/widgets/monthly_calendar.dart';

class GoalChartWidget extends StatelessWidget {
  final Goal goal;

  const GoalChartWidget({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: screenHeight * 0.75,
      child: ListView(
        children: <Widget>[
          Text(
            goal.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          MonthlyCalendar(goal: goal),
          const SizedBox(height: 20),
          Text(
            'achievements'.tr(),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          GoalAchievementPercentWidget(goal: goal),
          const SizedBox(height: 20),
          Text(
            'weekly_graph'.tr(),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          ChartByDayOfWeekWidget(goal: goal),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
