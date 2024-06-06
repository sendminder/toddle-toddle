import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/utils/id_generator.dart';
import 'package:toddle_toddle/widgets/week_days_toggle.dart';
import 'package:toddle_toddle/utils/time.dart';
import 'package:get_it/get_it.dart';
import 'package:toddle_toddle/widgets/editable/name_text_form.dart';
import 'package:toddle_toddle/widgets/editable/color_picker_form.dart';

// ignore: must_be_immutable
class AddOrUpdateGoalBottomSheet extends ConsumerWidget {
  AddOrUpdateGoalBottomSheet(
      {super.key, required this.goal, required this.init}) {
    goalNameProvider = StateProvider<String>((ref) => goal.name);
    selectedModeProvider = StateProvider<String>(
        (ref) => goal.schedule.isDaily == true ? 'Daily' : 'Weekly');
    needPushProvider = StateProvider<bool>((ref) => goal.needPush);
    startDateProvider = StateProvider<DateTime>((ref) => goal.startDate);
    notificationTimeProvider =
        StateProvider<String>((ref) => goal.schedule.notificationTime);
    selectedDaysProvider =
        StateProvider<List<int>>((ref) => goal.schedule.daysOfWeek);
    colorProvider = StateProvider<Color>((ref) => goal.color);
  }
  final bool init;
  final Goal goal;
  late StateProvider<String> goalNameProvider;
  late StateProvider<String> selectedModeProvider;
  late StateProvider<String> notificationTimeProvider;
  late StateProvider<DateTime> startDateProvider;
  late StateProvider<List<int>> selectedDaysProvider;
  late StateProvider<Color> colorProvider;
  late StateProvider<bool> needPushProvider;

  final idGenerator = GetIt.I<IdGenerator>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(selectedModeProvider);
    final startDate = ref.watch(startDateProvider);
    final notificationTime = ref.watch(notificationTimeProvider);
    final selectedDays = ref.watch(selectedDaysProvider);
    final goalName = ref.watch(goalNameProvider);
    final goalColor = ref.watch(colorProvider);
    final needPush = ref.watch(needPushProvider);

    const header = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    var textButtonStyle = TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      foregroundColor: goalColor,
      backgroundColor: goalColor.withAlpha(40),
      minimumSize: const Size(340, 48),
    );

    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    var lastDay = now.add(const Duration(days: 90));
    var firstDay = now.add(const Duration(days: -365));

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: 600,
      child: ListView(
        children: <Widget>[
          Text(
            'goal_name'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          NameTextForm(
            colorProvider: colorProvider,
            stringProvider: goalNameProvider,
            initText: goal.name,
          ),
          const SizedBox(height: 20),
          Text(
            'colors'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          ColorPickerFormWidget(colorProvider: colorProvider),
          Text(
            'start_date'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Center(
            child: TextButton(
              style: textButtonStyle,
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: startDate,
                  firstDate: firstDay,
                  lastDate: lastDay,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: goalColor,
                        colorScheme: ColorScheme.light(primary: goalColor),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null && picked != startDate) {
                  var selected =
                      DateTime(picked.year, picked.month, picked.day);
                  ref.read(startDateProvider.notifier).state = selected;
                }
              },
              child: Text(
                timeToYearMonthDay(startDate),
                style: TextStyle(
                  fontSize: 16,
                  color: goalColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'schedule'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Center(
            child: Column(
              children: [
                ToggleButtons(
                  constraints:
                      const BoxConstraints(minWidth: 170, minHeight: 48),
                  borderRadius: BorderRadius.circular(16),
                  fillColor: goalColor.withAlpha(40),
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
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'daily'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: goalColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'weekly'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: goalColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedMode == 'Weekly') ...[
                  // Weekly 선택 시 나타나는 요일 토글 버튼
                  const SizedBox(height: 20),
                  WeekDaysToggle(
                    selectedDaysProvider: selectedDaysProvider,
                    colorProvider: colorProvider,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: TextButton(
              style: textButtonStyle,
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.dialOnly,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: goalColor,
                        colorScheme: ColorScheme.light(primary: goalColor),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  final String formattedTime = timeOfDayToString(pickedTime);
                  ref.read(notificationTimeProvider.notifier).state =
                      formattedTime;
                }
              },
              child: Text(
                notificationTime,
                style: TextStyle(
                  fontSize: 14,
                  color: goalColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'notifications'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          Center(
            child: Column(
              children: [
                ToggleButtons(
                  constraints:
                      const BoxConstraints(minWidth: 170, minHeight: 48),
                  borderRadius: BorderRadius.circular(16),
                  fillColor: goalColor.withAlpha(40),
                  isSelected: [
                    needPush == true,
                    needPush == false,
                  ],
                  onPressed: (int index) {
                    goal.schedule.isDaily = index == 0;
                    ref.read(needPushProvider.notifier).state =
                        index == 0 ? true : false;
                  },
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'enable'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: goalColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'disable'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: goalColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Spacer(),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: goalColor.withAlpha(40),
                backgroundColor: goalColor,
                minimumSize: const Size(200, 48),
              ),
              onPressed: () async {
                if (goal.id == 0) {
                  goal.id = await idGenerator.generateUniqueId();
                }
                goal.name = goalName;
                goal.startDate = startDate;
                goal.color = goalColor;
                goal.needPush = needPush;
                Schedule schedule = Schedule(
                  daysOfWeek: selectedDays,
                  notificationTime: notificationTime,
                  isDaily: selectedMode == 'Daily',
                );
                goal.schedule = schedule;

                if (context.mounted) {
                  if (goal.name.isEmpty) {
                    showAlertDialog(context, 'goal_name_empty'.tr());
                    return;
                  }
                  if (!goal.schedule.isDaily &&
                      goal.schedule.daysOfWeek.isEmpty) {
                    showAlertDialog(context, 'select_days_of_week'.tr());
                    return;
                  }
                  await ref
                      .read(goalsStateProvider.notifier)
                      .addOrUpdateGoal(goal);
                  ref.read(goalsStateProvider.notifier).printAll();

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: init
                  ? Text(
                      'add'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'update'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text('alert'.tr()),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('button_positive'.tr()),
            ),
          ],
        );
      },
    );
  }
}
