import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';

class ColorPickerFormWidget extends ConsumerWidget {
  // 18개의 색상을 정의
  List<Color> colors = const [
    Color(0xFFE74C3C),
    Color(0xFFFF7878),
    Color(0xFFF06292),
    Color(0xFFBA68C8),
    Color(0xFF9575CD),
    Color(0xFF7986CB),
    Color(0xFF3498DB),
    Color(0xFF64B5F6),
    Color(0xFF4FC3F7),
    Color(0xFF4DD0E1),
    Color(0xFF4DB6AC),
    Color(0xFF81C784),
    Color(0xFFA0C36C),
    Color(0xFFFFC107),
    Color(0xFFFFB74D),
    Color(0xFFA1887F),
    Color(0xFF909090),
    Color(0xFF90A4AE),
  ];

  ColorPickerFormWidget({
    super.key,
    required this.colorProvider,
  });

  final StateProvider<Color> colorProvider;
  final logger = GetIt.I<Logger>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(colorProvider);

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        return GestureDetector(
          onTap: () {
            ref.read(colorProvider.notifier).state = color;
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedColor.value == color.value
                    ? Colors.black
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
        );
      },
    );
  }
}
