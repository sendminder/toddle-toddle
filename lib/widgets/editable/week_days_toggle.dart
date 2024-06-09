import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeekDaysToggle extends ConsumerWidget {
  WeekDaysToggle({
    super.key,
    required this.selectedDays,
    required this.onSelectedChanged,
    required this.color,
  });
  List<int> selectedDays;
  ValueChanged<List<int>> onSelectedChanged;
  Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        List.generate(7, (index) => selectedDays.contains(index));
    final style = TextStyle(
      fontSize: 13,
      color: color,
    );

    final screenWidth = MediaQuery.of(context).size.width;

    return ToggleButtons(
      constraints: BoxConstraints(
        minWidth: (screenWidth - 40) / 7,
        maxWidth: (screenWidth - 40) / 7,
        minHeight: 48,
      ),
      borderRadius: BorderRadius.circular(16),
      fillColor: color.withAlpha(60),
      isSelected: isSelected,
      onPressed: (int index) {
        final newList = [...selectedDays];
        if (newList.contains(index)) {
          newList.remove(index);
        } else {
          newList.add(index);
        }
        selectedDays = newList..sort(); // 리스트를 정렬합니다.
        onSelectedChanged(selectedDays);
      },
      children: [
        Text(
          'monday'.tr(),
          style: style,
        ),
        Text(
          'tuesday'.tr(),
          style: style,
        ),
        Text(
          'wednesday'.tr(),
          style: style,
        ),
        Text(
          'thursday'.tr(),
          style: style,
        ),
        Text(
          'friday'.tr(),
          style: style,
        ),
        Text(
          'saturday'.tr(),
          style: style,
        ),
        Text(
          'sunday'.tr(),
          style: style,
        ),
      ],
    );
  }
}
