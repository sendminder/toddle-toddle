import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';
import 'package:toddle_toddle/utils/color_palette.dart';

class ColorPickerFormWidget extends ConsumerWidget {
  ColorPickerFormWidget({
    super.key,
    required this.colorProvider,
  });

  final StateProvider<Color> colorProvider;
  final logger = GetIt.I<Logger>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(colorProvider);

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 22,
          mainAxisSpacing: 12,
        ),
        itemCount: palette.length,
        itemBuilder: (context, index) {
          final color = palette[index];
          return GestureDetector(
            onTap: () {
              ref.read(colorProvider.notifier).state = color;
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedColor.value == color.value
                      ? Colors.black38
                      : Colors.transparent,
                  width: 3.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
