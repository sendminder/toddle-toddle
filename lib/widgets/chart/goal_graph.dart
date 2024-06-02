import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:toddle_toddle/states/goal_filter_state.dart';

class GoalGraphWidget extends ConsumerWidget {
  const GoalGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goals = ref.watch(goalsStateProvider);
    var filterTypeState = ref.watch(goalFilterProvider);

    switch (filterTypeState.type) {
      case FilterType.all:
        break;
      case FilterType.active:
        goals = goals.where((element) => element.isEnd == false).toList();
        break;
      case FilterType.completed:
        goals = goals.where((element) => element.isEnd == true).toList();
        break;
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: 800,
      child: ListView(
        children: [
          const SizedBox(height: 15),
          Text('goal_graph'.tr(), style: const TextStyle(fontSize: 20)),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == 0;
      final double fontSize = isTouched ? 20 : 18;
      final double radius = isTouched ? 50 : 50;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 75,
            title: '75%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
