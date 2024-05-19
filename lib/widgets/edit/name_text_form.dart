import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameTextForm extends ConsumerWidget {
  const NameTextForm(
      {super.key, required this.stringProvider, required this.initText});

  final String initText;
  final StateProvider<String> stringProvider;

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    return TextFormField(
      initialValue: initText,
      decoration: InputDecoration(
        labelText: 'goal_name'.tr(),
      ),
      onChanged: (value) {
        ref.read(stringProvider.notifier).state = value;
      },
    );
  }
}
