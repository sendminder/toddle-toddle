import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toddle_toddle/data/enums/color_palette_type.dart';
import 'package:toddle_toddle/states/theme_mode_state.dart';
import 'package:toddle_toddle/states/push_notification_state.dart';
import 'package:toddle_toddle/states/goals_state.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:toddle_toddle/states/font_state.dart';
import 'package:toddle_toddle/const/cheer_up_messages.dart';

// ignore: must_be_immutable
class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key}) {
    version = Hive.box(hivePrefBox).get('version', defaultValue: '') as String;
  }
  late String version;

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text('select_language'.tr()),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                context.setLocale(const Locale('en'));
                CheerUpMessages.setLanguage(context.locale.languageCode);
                await ref.read(goalsStateProvider.notifier).syncSchedule();

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text('en'.tr()),
            ),
            SimpleDialogOption(
              onPressed: () async {
                context.setLocale(const Locale('ko'));
                CheerUpMessages.setLanguage(context.locale.languageCode);
                await ref.read(goalsStateProvider.notifier).syncSchedule();

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text('ko'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showFontPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text('select_font'.tr()),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                ref.read(fontProvider.notifier).setFont('System');
                Navigator.pop(context);
              },
              child: Text(
                'system_example'.tr(),
                style: const TextStyle(
                  fontFamily: '',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref.read(fontProvider.notifier).setFont('NotoSans');
                Navigator.pop(context);
              },
              child: Text(
                'notosans_example'.tr(),
                style: const TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref.read(fontProvider.notifier).setFont('SUITE');
                Navigator.pop(context);
              },
              child: Text(
                'suite_example'.tr(),
                style: const TextStyle(
                  fontFamily: 'SUITE',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref.read(fontProvider.notifier).setFont('Nunito');
                Navigator.pop(context);
              },
              child: Text(
                'nunito_example'.tr(),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref.read(fontProvider.notifier).setFont('CoockieRun');
                Navigator.pop(context);
              },
              child: Text(
                'cookierun_example'.tr(),
                style: const TextStyle(
                  fontFamily: 'CoockieRun',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final yellos = [
          const Color(0xFFF3B74B),
          const Color(0xFFD9C6C0),
          const Color(0xFFEFE7E5),
          const Color(0xFF4D3405),
        ];

        final purples = [
          const Color(0xFF6366F1),
          const Color(0xFFA5B4FC),
          const Color(0xFFE2E8F0),
          const Color(0xFF0F172A),
        ];

        final greens = [
          const Color(0xFF34D399),
          const Color(0xFFB5C3D2),
          const Color(0xFFC5F2E2),
          const Color(0xFF08271C),
        ];

        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text('select_theme'.tr()),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                ref
                    .read(themeProvider.notifier)
                    .setColorPaletteType(ColorPaletteType.yellow);
                Navigator.pop(context);
              },
              child: _buildColorOption(context, 'yellow'.tr(), yellos),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref
                    .read(themeProvider.notifier)
                    .setColorPaletteType(ColorPaletteType.purple);
                Navigator.pop(context);
              },
              child: _buildColorOption(context, 'purple'.tr(), purples),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref
                    .read(themeProvider.notifier)
                    .setColorPaletteType(ColorPaletteType.green);
                Navigator.pop(context);
              },
              child: _buildColorOption(context, 'green'.tr(), greens),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorOption(
      BuildContext context, String text, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            color: colors[0],
            shape: BoxShape.rectangle,
          ),
        ),
        Container(
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            color: colors[1],
            shape: BoxShape.rectangle,
          ),
        ),
        Container(
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            color: colors[2],
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
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
    final font = ref.watch(fontProvider);

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
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListTile(
                trailing: Text(
                  themeMode.colorPaletteType.toStringValue().tr(),
                  style: primaryColorStyle,
                  textAlign: TextAlign.end,
                ),
                title: Text(
                  'theme_title'.tr(),
                  style: normalStyle,
                ),
                subtitle: Text(
                  'theme_subtitle'.tr(),
                  style: smalStyle,
                ),
                onTap: () {
                  _showThemePicker(context, ref);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListTile(
                trailing: Text(
                  font.font,
                  style: primaryColorStyle,
                  textAlign: TextAlign.end,
                ),
                title: Text(
                  'font_title'.tr(),
                  style: normalStyle,
                ),
                subtitle: Text(
                  'font_subtitle'.tr(),
                  style: smalStyle,
                ),
                onTap: () {
                  _showFontPicker(context, ref);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListTile(
                trailing: Text(
                  selectedLanguageName.tr(),
                  style: primaryColorStyle,
                  textAlign: TextAlign.end,
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
                  _showLanguagePicker(context, ref);
                },
              ),
            ),
            divider,
            ListTile(
              title: Text(
                'info'.tr(),
                style: boldStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListTile(
                trailing: Text(
                  version,
                  style: primaryColorStyle,
                  textAlign: TextAlign.end,
                ),
                title: Text(
                  'version'.tr(),
                  style: normalStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
