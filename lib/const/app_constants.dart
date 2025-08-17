class AppConstants {
  // Hive 관련 상수
  static const String hivePrefBox = 'prefs';
  static const String hiveGoalBox = 'goals';

  // 시간 관련 상수
  static const int syncIntervalSeconds = 60 * 60 * 24; // 24시간
  static const int splashDuration = 500; // milliseconds

  // 기본 로케일
  static const String defaultLocale = 'ko';
  static const List<String> supportedLocales = ['en', 'ko'];
}
