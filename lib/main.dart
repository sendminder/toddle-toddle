import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';

import 'config/theme.dart';
import 'states/theme_mode_state.dart';
import 'screens/home_screen.dart';
import 'const/strings.dart';

import 'package:toddle_toddle/service/local_push_service.dart';

void main() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<Logger>(Logger());
  GetIt.I.registerSingleton<LocalPushService>(LocalPushService());
  await GetIt.I<LocalPushService>().init();
  await EasyLocalization.ensureInitialized();

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(AchievementAdapter());
  Hive.registerAdapter(ScheduleAdapter());

  await Hive.openBox(HivePrefBox);
  await Hive.openBox<Goal>(HiveGoalBox);

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
