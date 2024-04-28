import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';

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
        CustomText(
          text: 'monday',
          textSize: 12,
        ),
        CustomText(
          text: 'tuesday',
          textSize: 12,
        ),
        CustomText(
          text: 'wednesday',
          textSize: 12,
        ),
        CustomText(
          text: 'thursday',
          textSize: 12,
        ),
        CustomText(
          text: 'friday',
          textSize: 12,
        ),
        CustomText(
          text: 'saturday',
          textSize: 12,
        ),
        CustomText(
          text: 'sunday',
          textSize: 12,
        ),
      ],
    );
  }
}
