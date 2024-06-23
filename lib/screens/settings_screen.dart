import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
import 'package:toddle_toddle/const/style.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key}) {
    version = Hive.box(hivePrefBox).get('version', defaultValue: '') as String;
  }
  late String version;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PushNotificationState pushEnable = ref.watch(pushNotificationProvider);
    ThemeModeState themeMode = ref.watch(themeProvider);
    const divider = Divider(
      height: 3,
      thickness: 0.2,
      indent: 5,
      endIndent: 5,
      color: Colors.grey,
    );
    var selectedLanguageName = context.locale.toString();
    const normalStyle = TextStyle(fontSize: 16);
    const smallStyle = TextStyle(fontSize: 14);
    const boldStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    var primaryColorStyle = TextStyle(
      fontSize: 15,
      color: Theme.of(context).colorScheme.primary,
    );
    final font = ref.watch(fontProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                style: smallStyle,
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
                style: smallStyle,
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
                  style: smallStyle,
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
                  style: smallStyle,
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
                  style: smallStyle,
                ),
                onTap: () {
                  _showLanguagePicker(context, ref);
                },
              ),
            ),
            divider,
            ListTile(
              title: Text(
                'support'.tr(),
                style: boldStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListTile(
                trailing: Icon(
                  FluentIcons.mail_add_24_regular,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'send_feedback'.tr(),
                  style: normalStyle,
                ),
                subtitle: Text(
                  'send_feedback_subtitle'.tr(),
                  style: smallStyle,
                ),
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'email'.tr(),
                    queryParameters: {
                      'subject': 'feedback_subject'.tr(),
                      'body': 'App Version :$version'
                    },
                  );
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  } else {
                    throw 'Could not launch $emailLaunchUri';
                  }
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 8),
            //   child: ListTile(
            //     trailing: Icon(
            //       FluentIcons.drink_coffee_24_regular,
            //       color: Theme.of(context).colorScheme.primary,
            //     ),
            //     title: Text(
            //       'support_developer'.tr(),
            //       style: normalStyle,
            //     ),
            //     subtitle: Text(
            //       'support_developer_subtitle'.tr(),
            //       style: smallStyle,
            //     ),
            //     onTap: () {
            //       _showLanguagePicker(context, ref);
            //     },
            //   ),
            // ),
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text('select_language'.tr()),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                context.setLocale(const Locale('en'));
                CheerUpMessages.setLanguage(context.locale.languageCode);
                ref.read(goalsStateProvider.notifier).syncSchedule();
              },
              child: Text('en'.tr(), style: contentStyle),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                context.setLocale(const Locale('ko'));
                CheerUpMessages.setLanguage(context.locale.languageCode);
                ref.read(goalsStateProvider.notifier).syncSchedule();
              },
              child: Text('ko'.tr(), style: contentStyle),
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
          backgroundColor: Theme.of(context).colorScheme.surface,
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
        const yello = Color(0xFFFFB74C);
        final yellos = [
          yello,
          yello.withAlpha(150),
          yello.withAlpha(30),
        ];

        const purple = Color(0xFF6366F1);
        final purples = [
          purple,
          purple.withAlpha(150),
          purple.withAlpha(30),
        ];

        const green = Color(0xFF28B883);
        final greens = [
          green,
          green.withAlpha(150),
          green.withAlpha(30),
        ];

        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // 회색 테두리
            borderRadius: BorderRadius.circular(9.0), // 테두리 둥글기 (선택 사항)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: colors[0],
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0)),
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
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Text(
          text,
          style: TextStyle(
            color: colors[0],
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
