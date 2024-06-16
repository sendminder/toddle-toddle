import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/utils/id_generator.dart';
import 'package:toddle_toddle/widgets/editable/week_days_toggle.dart';
import 'package:toddle_toddle/utils/time.dart';
import 'package:get_it/get_it.dart';
import 'package:toddle_toddle/widgets/editable/color_picker_form.dart';
import 'package:toddle_toddle/states/goal_provider.dart';
import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/enums/schedule_type.dart';

// ignore: must_be_immutable
class AddOrUpdateGoalBottomSheet extends ConsumerWidget {
  AddOrUpdateGoalBottomSheet(
      {super.key, required this.initGoal, required this.init});
  final bool init;
  final Goal initGoal;

  final idGenerator = GetIt.I<IdGenerator>();
  var notificationTimeOfDay = TimeOfDay.fromDateTime(DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(goalProvider.notifier).initGoal(initGoal);
    final goalState = ref.watch(goalProvider);
    final goal = goalState.goal;
    String notificationTime = goal.schedule.notificationTime;
    DateTime startDate = goal.startDate;
    List<int> selectedDays = goal.schedule.daysOfWeek;
    Color goalColor = goal.color;
    bool needPush = goal.needPush;
    ScheduleType scheduleType = goal.schedule.scheduleType;

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: screenHeight * 0.75,
      child: ListView(
        children: <Widget>[
          Text(
            'goal_name'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          TextFormField(
            cursorColor: goalColor,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: goalColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: goalColor),
              ),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: goalColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            initialValue: goal.name,
            onChanged: (value) {
              ref.read(goalProvider.notifier).updateName(value);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'colors'.tr(),
            style: header,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          ColorPickerFormWidget(
              selectedColor: goalColor,
              onColorChanged: (newColor) {
                ref.read(goalProvider.notifier).updateColor(newColor);
              }),
          const SizedBox(height: 20),
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
                  startDate = selected;
                  ref.read(goalProvider.notifier).updateStartDate(selected);
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
                  constraints: BoxConstraints(
                    minWidth: (screenWidth - 40) / 3,
                    maxWidth: (screenWidth - 40) / 3,
                    minHeight: 48,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  fillColor: goalColor.withAlpha(40),
                  isSelected: [
                    scheduleType == ScheduleType.once,
                    scheduleType == ScheduleType.daily,
                    scheduleType == ScheduleType.weekly,
                  ],
                  onPressed: (int index) {
                    // 선택된 모드 업데이트
                    goal.schedule.scheduleType =
                        ScheduleTypeExtension.fromIntValue(index);
                    ref.read(goalProvider.notifier).updateScheduleType(
                        ScheduleTypeExtension.fromIntValue(index));
                  },
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'once'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: goalColor,
                        ),
                      ),
                    ),
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
                if (ref
                        .read(goalProvider.notifier)
                        .goal
                        .schedule
                        .scheduleType ==
                    ScheduleType.weekly) ...[
                  // Weekly 선택 시 나타나는 요일 토글 버튼
                  const SizedBox(height: 20),
                  WeekDaysToggle(
                      selectedDays: selectedDays,
                      color: goalColor,
                      onSelectedChanged: (days) {
                        ref
                            .read(goalProvider.notifier)
                            .updateSelectedDays(days);
                      }),
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
                  initialTime: notificationTimeOfDay,
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
                  notificationTimeOfDay = pickedTime;
                  notificationTime = formattedTime;
                  ref
                      .read(goalProvider.notifier)
                      .updateNotificationTime(formattedTime);
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
          const SizedBox(height: 5),
          Center(
            child: Column(
              children: [
                ToggleButtons(
                  constraints: BoxConstraints(
                    minWidth: (screenWidth - 40) / 2,
                    maxWidth: (screenWidth - 40) / 2,
                    minHeight: 48,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  fillColor: goalColor.withAlpha(40),
                  isSelected: [
                    needPush == true,
                    needPush == false,
                  ],
                  onPressed: (int index) {
                    goal.needPush = index == 0;
                    needPush = index == 0 ? true : false;
                    ref.read(goalProvider.notifier).updateNeedPush(needPush);
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
          const SizedBox(height: 30),
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
                Schedule schedule = Schedule(
                  daysOfWeek: selectedDays,
                  notificationTime: notificationTime,
                  scheduleType: scheduleType,
                );
                goal.schedule = schedule;

                if (context.mounted) {
                  if (goal.name.isEmpty) {
                    showAlertDialog(context, 'goal_name_empty'.tr());
                    return;
                  }
                  if (goal.schedule.scheduleType == ScheduleType.weekly &&
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
