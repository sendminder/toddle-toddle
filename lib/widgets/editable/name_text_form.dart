import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameTextForm extends ConsumerWidget {
  const NameTextForm(
      {super.key,
      required this.colorProvider,
      required this.stringProvider,
      required this.initText});

  final StateProvider<Color> colorProvider;
  final StateProvider<String> stringProvider;
  final String initText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(colorProvider);
    return TextFormField(
      cursorColor: color,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      initialValue: initText,
      onChanged: (value) {
        ref.read(stringProvider.notifier).state = value;
      },
    );
  }
}
