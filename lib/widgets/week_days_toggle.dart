import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toddle_toddle/widgets/custom_text.dart';

final selectedDaysProvider = StateProvider<List<int>>((ref) => []);

class WeekDaysToggle extends ConsumerWidget {
  const WeekDaysToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDays = ref.watch(selectedDaysProvider);
    List<bool> isSelected =
        List.generate(7, (index) => selectedDays.contains(index));

    return ToggleButtons(
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
      children: const [
        CustomText(text: 'monday', textSize: 12),
        CustomText(text: 'tuesday', textSize: 12),
        CustomText(text: 'wednesday', textSize: 12),
        CustomText(text: 'thursday', textSize: 12),
        CustomText(text: 'friday', textSize: 12),
        CustomText(text: 'saturday', textSize: 12),
        CustomText(text: 'sunday', textSize: 12),
      ],
    );
  }
}
