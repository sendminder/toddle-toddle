import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toddle_toddle/states/theme_mode_state.dart';
import 'package:toddle_toddle/states/push_notification_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key}) {
    version = Hive.box(hivePrefBox).get('version', defaultValue: '') as String;
  }
  late String version;

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text('select_language'.tr()),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
              child: Text('en'.tr()),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.setLocale(const Locale('ko'));
                Navigator.pop(context);
              },
              child: Text('ko'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PushNotificationState pushEnable = ref.watch(pushNotificationProvider);
    ThemeModeState themeMode = ref.watch(themeProvider);
    const divider = Divider(
      height: 3,
      thickness: 0.3,
      color: Colors.grey,
    );
    var selectedLanguageName = context.locale.toString();
    const normalStyle = TextStyle(fontSize: 16);
    const smalStyle = TextStyle(fontSize: 14);
    const boldStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    var primaryColorStyle = TextStyle(
      fontSize: 15,
      color: Theme.of(context).colorScheme.primary,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
          children: <Widget>[
            const SizedBox(height: 15),
            ListTile(
              title: Text(
                'notifications'.tr(),
                style: boldStyle,
              ),
            ),
            SwitchListTile(
              title: Text(
                'push_setting_title'.tr(),
                style: normalStyle,
              ),
              subtitle: Text(
                'push_setting_subtitle'.tr(),
                style: smalStyle,
              ),
              value: pushEnable.pushNotificationEnable!,
              onChanged: (bool value) async {
                pushEnable.setPushNotificationEnable(value);
                if (value) {
                  await ref.read(goalsStateProvider.notifier).syncSchedule();
                } else {
                  await ref
                      .read(goalsStateProvider.notifier)
                      .cancelAllSchedule();
                }
              },
            ),
            divider,
            ListTile(
              title: Text(
                'appearance'.tr(),
                style: boldStyle,
              ),
            ),
            SwitchListTile(
              title: Text(
                'dark_mode_title'.tr(),
                style: normalStyle,
              ),
              subtitle: Text(
                'dark_mode_content'.tr(),
                style: smalStyle,
              ),
              value: themeMode.currentThemeMode == ThemeMode.dark,
              onChanged: (bool value) {
                if (value) {
                  themeMode.setThemeMode(ThemeMode.dark);
                } else {
                  themeMode.setThemeMode(ThemeMode.light);
                }
              },
            ),
            ListTile(
              trailing: Text(
                '${selectedLanguageName.tr()} ',
                style: primaryColorStyle,
                textAlign: TextAlign.start,
              ),
              title: Text(
                'language_title'.tr(),
                style: normalStyle,
              ),
              subtitle: Text(
                'language_content'.tr(),
                style: smalStyle,
              ),
              onTap: () {
                _showLanguagePicker(context);
              },
            ),
            divider,
            ListTile(
              title: Text(
                'info'.tr(),
                style: boldStyle,
              ),
            ),
            ListTile(
              trailing: Text(
                '$version  ',
                style: primaryColorStyle,
                textAlign: TextAlign.start,
              ),
              title: Text(
                'version'.tr(),
                style: normalStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
