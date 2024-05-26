import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/goal.dart';

class GoalAchievementPercentWidget extends StatelessWidget {
  const GoalAchievementPercentWidget({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    int totalAchievements = goal.achievements.where((a) => a.achieved).length;
    var lastDay = DateTime.now();
    if (goal.endTime != null) {
      lastDay = goal.endTime!;
    }
    int totalDays = lastDay.difference(goal.startDate).inDays + 1;
    double achievementPercentage = (totalAchievements / totalDays) * 100;

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
            'Total Achievements: $totalAchievements',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Total Days: $totalDays',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Achievement Percentage: ${achievementPercentage.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 20),
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
                width: (achievementPercentage / 100) *
                    MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: goal.color.withAlpha(220),
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
