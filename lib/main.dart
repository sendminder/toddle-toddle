import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:toddle_toddle/utils/id_generator.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';

import 'package:toddle_toddle/const/strings.dart';
import 'config/theme.dart';
import 'states/theme_mode_state.dart';
import 'screens/home_screen.dart';

import 'package:toddle_toddle/service/local_push_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<Logger>(Logger());
  GetIt.I.registerSingleton<LocalPushService>(LocalPushService());
  await GetIt.I<LocalPushService>().init();
  await EasyLocalization.ensureInitialized();
  await setupTimeZone();

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(AchievementAdapter());
  Hive.registerAdapter(ScheduleAdapter());

  GetIt.I.registerSingleton<IdGenerator>(IdGenerator());
  await Hive.openBox(hivePrefBox);
  // await Hive.deleteBoxFromDisk(hiveGoalBox);
  await Hive.openBox<Goal>(hiveGoalBox);
  await setupVersion();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const <Locale>[
          Locale('en'),
          Locale('ko'),
        ],
        fallbackLocale: const Locale('en'),
        useFallbackTranslations: true,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState currentTheme = ref.watch(themeProvider);
    // if (Platform.isAndroid) {
    return MaterialApp(
      /// Localization is not available for the title.
      title: 'Toddle Toddle',

      /// Theme stuff
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentTheme.themeMode,

      /// Localization stuff
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
    // }
    // return CupertinoApp(
    //   title: 'Toddle Toddle',
    //   localizationsDelegates: context.localizationDelegates,
    //   supportedLocales: context.supportedLocales,
    //   locale: context.locale,
    //   debugShowCheckedModeBanner: false,
    //   home: const HomeScreen(),
    // );
  }
}

Future<void> setupTimeZone() async {
  tz.initializeTimeZones();
  String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> setupVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  Hive.box(hivePrefBox).put('version', packageInfo.version);
}
