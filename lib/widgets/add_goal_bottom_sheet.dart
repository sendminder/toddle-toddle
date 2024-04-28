import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/utils/id_generator.dart';

class AddGoalBottomSheet extends ConsumerWidget {
  String? goalName;
  DateTime? startDate;
  String frequency = 'Daily'; // 'Daily', 'Weekly', 'Custom'
  bool isDaily = true;
  List<int> selectedDays = [];
  String notificationTime = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);

    return Container(
      padding: EdgeInsets.all(16.0),
      height: 800,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: '목표 이름',
            ),
            onChanged: (value) {
              goalName = value;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
              );
              if (picked != null && picked != startDate) {
                startDate = picked;
              }
            },
            child: Text(startDate == null ? '시작 날짜 설정' : startDate.toString()),
          ),
          DropdownButton<String>(
            value: frequency,
            onChanged: (String? newValue) {
              frequency = newValue!;
            },
            items: <String>['Daily', 'Weekly', 'Custom']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // 시간 설정 버튼 추가
          ElevatedButton(
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                final String formattedTime = pickedTime.format(context);
                notificationTime = formattedTime; // 시간 업데이트
              }
            },
            child: Text('알림 시간 설정: $notificationTime'),
          ),
          if (frequency == 'Weekly')
            Wrap(
              children: List<Widget>.generate(7, (int index) {
                String day = '월화수목금토일'[index];
                return ChoiceChip(
                    label: Text(day),
                    selected: selectedDays.contains(day),
                    onSelected: (bool selected) {
                      if (selected) {
                        selectedDays.add(index);
                      } else {
                        selectedDays.remove(index);
                      }
                    });
              }),
            ),
          ElevatedButton(
            onPressed: () async {
              if (frequency == 'Weekly') {
                isDaily = false;
              }
              String id = generateUniqueId();
              Schedule schedule = Schedule(
                daysOfWeek: selectedDays,
                notificationTime: notificationTime,
                startDate: startDate!,
                isDaily: isDaily,
              );
              Goal newGoal = Goal(
                id: id,
                name: goalName!,
                startTime: startDate!,
                schedule: schedule,
              );
              await ref
                  .read(goalsStateProvider.notifier)
                  .addOrUpdateGoal(newGoal);
              ref.read(goalsStateProvider.notifier).printAll();
              Navigator.pop(context);
            },
            child: Text('추가하기'),
          ),
        ],
      ),
    );
  }
}
