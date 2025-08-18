import 'dart:async';
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
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:toddle_toddle/data/models/goal.dart';
import 'package:toddle_toddle/data/models/schedule.dart';
import 'package:toddle_toddle/data/models/achievement.dart';

import 'package:toddle_toddle/const/app_constants.dart';
import 'config/theme.dart';
import 'package:toddle_toddle/states/font_state.dart';
import 'states/theme_mode_state.dart';
import 'screens/home_screen.dart';

import 'package:toddle_toddle/service/local_push_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toddle_toddle/data/adapter/filter_type_adapter.dart';
import 'package:toddle_toddle/data/adapter/color_palette_type_adapter.dart';
import 'package:toddle_toddle/data/adapter/schedule_type_adapter.dart';
import 'package:toddle_toddle/const/cheer_up_messages.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<WidgetsBinding> initializeApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Hive를 먼저 초기화
  await _initializeHive();

  // 그 다음 다른 서비스들을 백그라운드에서 초기화
  unawaited(_initializeServices());
  unawaited(setupVersion());

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  return widgetsBinding;
}

Future<void> _initializeServices() async {
  try {
    GetIt.I.registerSingleton<Logger>(Logger());
    GetIt.I.registerSingleton<LocalPushService>(LocalPushService());
    await GetIt.I<LocalPushService>().init();
    await EasyLocalization.ensureInitialized();
    await setupTimeZone();

    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  } catch (e) {
    // 에러 로깅
    print('Service initialization error: $e');
  }
}

Future<void> _initializeHive() async {
  try {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);

    _registerHiveAdapters();

    GetIt.I.registerSingleton<IdGenerator>(IdGenerator());

    // Hive 박스들을 순차적으로 열기
    await Hive.openBox(AppConstants.hivePrefBox);
    await Hive.openBox<Goal>(AppConstants.hiveGoalBox);

    print('Hive initialization completed successfully');
  } catch (e) {
    print('Hive initialization error: $e');
  }
}

void _registerHiveAdapters() {
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(AchievementAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(GoalFilterTypeAdapter());
  Hive.registerAdapter(ColorPaletteTypeAdapter());
  Hive.registerAdapter(ScheduleTypeAdapter());
}

void main() async {
  final widgetsBinding = await initializeApp();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: [
          for (final locale in AppConstants.supportedLocales) Locale(locale),
        ],
        fallbackLocale: const Locale(AppConstants.defaultLocale),
        useFallbackTranslations: true,
        child: const MyApp(),
      ),
    ),
  );

  // 스플래시 스크린을 더 일찍 제거하여 사용자 경험 개선
  Timer(const Duration(milliseconds: AppConstants.splashDuration), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState currentTheme = ref.watch(themeProvider);
    final FontState currentFont = ref.watch(fontProvider);
    final CustomThemeData customTheme = CustomThemeData(
        font: currentFont.font,
        paletteType: currentTheme.currentColorPaletteType);
    CheerUpMessages.setLanguage(context.locale.languageCode);

    return MaterialApp(
      title: 'app_name'.tr(),
      theme: customTheme.lightTheme,
      darkTheme: customTheme.darkTheme,
      themeMode: currentTheme.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

Future<void> setupTimeZone() async {
  tz.initializeTimeZones();
  String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> setupVersion() async {
  try {
    // Hive 박스가 열려있는지 확인
    if (!Hive.isBoxOpen(AppConstants.hivePrefBox)) {
      await Hive.openBox(AppConstants.hivePrefBox);
    }

    final packageInfo = await PackageInfo.fromPlatform();
    Hive.box(AppConstants.hivePrefBox).put('version', packageInfo.version);
  } catch (e) {
    print('Version setup error: $e');
  }
}
