import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toddle_toddle/states/theme_mode_state.dart';

import 'package:toddle_toddle/widgets/custom_text.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('언어 선택'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
              child: const Text('English'),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.setLocale(const Locale('ko'));
                Navigator.pop(context);
              },
              child: const Text('한국어'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'title_third',
          textSize: 20,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            SwitchListTile(
              title: const CustomText(
                text: 'dark_mode_title',
                textSize: 16,
              ),
              subtitle: const CustomText(
                text: 'dark_mode_content',
                textSize: 14,
              ),
              value: ref.read(themeProvider.notifier).currentThemeMode ==
                  ThemeMode.dark,
              onChanged: (bool value) {
                if (value) {
                  ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
                } else {
                  ref
                      .read(themeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                }
              },
            ),
            ListTile(
              title: const CustomText(
                text: 'language_title',
                textSize: 16,
              ),
              subtitle: const CustomText(
                text: 'language_content',
                textSize: 14,
              ),
              onTap: () {
                _showLanguagePicker(context);
              },
            ),
            // SwitchListTile(
            //   title: const Text('푸시 설정'),
            //   subtitle: const Text('푸시 알림을 받을지 여부 설정'),
            //   value: ref.watch(pushNotificationProvider),
            //   onChanged: (bool value) {
            //     ref.read(pushNotificationProvider.notifier).state = value;
            //   },
            // ),
            // SwitchListTile(
            //   title: const Text('알림 설정'),
            //   subtitle: const Text('알림을 받을지 여부 설정'),
            //   value: ref.watch(notificationProvider),
            //   onChanged: (bool value) {
            //     ref.read(notificationProvider.notifier).state = value;
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
