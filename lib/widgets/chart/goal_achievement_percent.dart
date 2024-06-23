import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';

class GoalAchievementPercentWidget extends StatelessWidget {
  const GoalAchievementPercentWidget({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    GoalStatistics goalStat = goal.getGoalStatistics();
    var width = MediaQuery.of(context).size.width;
    width = width - 64;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: goal.color.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'total_achievements'.tr()}: ${goalStat.totalAchievements}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '${'total_days'.tr()}: ${goalStat.totalDays}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '${'achievement_percentage'.tr()}: ${goalStat.achievementPercentage.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 20,
                width: (goalStat.achievementPercentage / 100) * width,
                decoration: BoxDecoration(
                  color: goal.color.withAlpha(230),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
