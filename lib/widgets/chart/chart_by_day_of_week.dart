import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:toddle_toddle/data/models/goal.dart';

class ChartByDayOfWeekWidget extends StatelessWidget {
  const ChartByDayOfWeekWidget({super.key, required this.goal});
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    // 요일별 달성 횟수 계산
    Map<int, int> dayOfWeekAchievementCount = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0
    };

    for (var achievement in goal.achievements) {
      if (achievement.achieved) {
        int dayOfWeek = achievement.date.weekday;
        dayOfWeekAchievementCount[dayOfWeek] =
            dayOfWeekAchievementCount[dayOfWeek]! + 1;
      }
    }

    List<BarChartGroupData> barGroups =
        dayOfWeekAchievementCount.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: goal.color.withAlpha(220),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: goal.color.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: barGroups,
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value == value.toInt()) {
                      return Text(value.toInt().toString());
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 1:
                        return Text('monday'.tr());
                      case 2:
                        return Text('tuesday'.tr());
                      case 3:
                        return Text('wednesday'.tr());
                      case 4:
                        return Text('thursday'.tr());
                      case 5:
                        return Text('friday'.tr());
                      case 6:
                        return Text('saturday'.tr());
                      case 7:
                        return Text('sunday'.tr());
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
