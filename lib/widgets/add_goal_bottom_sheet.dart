import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/utils/id_generator.dart';
import 'package:toddle_toddle/widgets/week_days_toggle.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';
import 'package:toddle_toddle/utils/time.dart';

class AddOrUpdateGoalBottomSheet extends ConsumerWidget {
  AddOrUpdateGoalBottomSheet({super.key, required this.goal});
  Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalNameProvider = StateProvider<String>((ref) => goal.name);
    final selectedModeProvider = StateProvider<String>(
        (ref) => goal.schedule.isDaily == true ? 'Daily' : 'Weekly');
    final startDateProvider = StateProvider<DateTime?>((ref) => goal.startTime);
    final notificationTimeProvider =
        StateProvider<String>((ref) => goal.schedule.notificationTime);

    final goalName = ref.watch(goalNameProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final startDate = ref.watch(startDateProvider);
    final notificationTime = ref.watch(notificationTimeProvider);
    final selectedDays = ref.watch(selectedDaysProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 800,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: goal.name,
            decoration: InputDecoration(
              labelText: 'goal_name'.tr(),
            ),
            onChanged: (value) {
              goal.name = value;
              ref.read(goalNameProvider.notifier).state = value;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                isSelected: [
                  selectedMode == 'Daily',
                  selectedMode == 'Weekly',
                ],
                onPressed: (int index) {
                  // 선택된 모드 업데이트
                  goal.schedule.isDaily = index == 0;
                  ref.read(selectedModeProvider.notifier).state =
                      index == 0 ? 'Daily' : 'Weekly';
                },
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      text: 'daily',
                      textSize: 12,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      text: 'weekly',
                      textSize: 12,
                    ),
                  ),
                ],
              ),
              if (selectedMode == 'Weekly') ...[
                // Weekly 선택 시 나타나는 요일 토글 버튼
                const SizedBox(height: 20),
                const WeekDaysToggle(),
              ],
            ],
          ),
          // 시간 설정 버튼 추가
          ElevatedButton(
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.dialOnly,
              );
              if (pickedTime != null) {
                final String formattedTime = timeOfDayToString(pickedTime);
                ref.read(notificationTimeProvider.notifier).state =
                    formattedTime;
              }
            },
            child: Text('알림 시간 설정: $notificationTime'),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () async {
              if (goal.id == '') {
                goal.id = generateUniqueId();
              }
              Schedule schedule = Schedule(
                daysOfWeek: selectedDays,
                notificationTime: notificationTime,
                startDate: startDate,
                isDaily: selectedMode == 'Daily',
              );
              goal.schedule = schedule;
              await ref.read(goalsStateProvider.notifier).addOrUpdateGoal(goal);
              ref.read(goalsStateProvider.notifier).printAll();
              Navigator.pop(context);
            },
            child: const CustomText(text: 'add_goal', textSize: 15.0),
          ),
        ],
      ),
    );
  }
}
