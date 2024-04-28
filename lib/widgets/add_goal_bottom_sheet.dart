import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/utils/id_generator.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';

class AddGoalBottomSheet extends ConsumerWidget {
  String? goalName;
  String frequency = 'Daily';
  bool isDaily = true;
  List<int> selectedDays = [];
  final selectedModeProvider = StateProvider<String>((ref) => 'Daily');
  final startDateProvider = StateProvider<DateTime?>((ref) => null);
  final notificationTimeProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsStateProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final startDate = ref.watch(startDateProvider);
    final notificationTime = ref.watch(notificationTimeProvider);

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
                ref.read(startDateProvider.notifier).state = picked;
              }
            },
            child: Text(startDate == null ? '시작 날짜 설정' : startDate.toString()),
          ),
          Column(
            children: [
              ToggleButtons(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Daily'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Weekly'),
                  ),
                ],
                isSelected: [
                  selectedMode == 'Daily',
                  selectedMode == 'Weekly',
                ],
                onPressed: (int index) {
                  // 선택된 모드 업데이트
                  ref.read(selectedModeProvider.notifier).state =
                      index == 0 ? 'Daily' : 'Weekly';
                },
              ),
              if (selectedMode == 'Weekly') ...[
                // Weekly 선택 시 나타나는 요일 토글 버튼
                SizedBox(height: 20),
                WeekDaysToggle(),
              ],
            ],
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
                ref.read(notificationTimeProvider.notifier).state =
                    formattedTime;
              }
            },
            child: Text('알림 시간 설정: $notificationTime'),
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

class WeekDaysToggle extends ConsumerWidget {
  final List<bool> _isSelected = List.generate(7, (_) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToggleButtons(
      isSelected: _isSelected,
      onPressed: (int index) {
        _isSelected[index] = !_isSelected[index];
      },
      children: [
        CustomText(text: 'monday'),
        CustomText(text: 'tuesday'),
        CustomText(text: 'wednesday'),
        CustomText(text: 'thursday'),
        CustomText(text: 'friday'),
        CustomText(text: 'saturday'),
        CustomText(text: 'sunday'),
      ],
    );
  }
}