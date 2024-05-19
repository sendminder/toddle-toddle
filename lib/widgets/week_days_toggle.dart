import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';

class WeekDaysToggle extends ConsumerWidget {
  const WeekDaysToggle({
    super.key,
    required this.selectedDaysProvider,
    required this.colorProvider,
  });
  final StateProvider<List<int>> selectedDaysProvider;
  final StateProvider<Color> colorProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDays = ref.watch(selectedDaysProvider);
    final color = ref.watch(colorProvider);
    final isSelected =
        List.generate(7, (index) => selectedDays.contains(index));
    final style = TextStyle(
      fontSize: 14,
      color: color,
    );

    return ToggleButtons(
      borderRadius: BorderRadius.circular(16),
      fillColor: color.withAlpha(60),
      isSelected: isSelected,
      onPressed: (int index) {
        ref.read(selectedDaysProvider.notifier).update((state) {
          final newList = [...state];
          if (newList.contains(index)) {
            newList.remove(index);
          } else {
            newList.add(index);
          }
          return newList..sort(); // 리스트를 정렬합니다.
        });
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
