import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';
import 'package:get_it/get_it.dart';
import 'package:toddle_toddle/service/local_push_service.dart';

final AutoDisposeChangeNotifierProvider<PushNotificationState>
    pushNotificationProvider = ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<PushNotificationState> ref) {
  return PushNotificationState();
});

class PushNotificationState extends ChangeNotifier with WidgetsBindingObserver {
  PushNotificationState() {
    WidgetsBinding.instance.addObserver(this);
    pushNotificationEnable = Hive.box(hivePrefBox)
        .get('pushNotificationEnable', defaultValue: true) as bool;
    checkPermission().then((value) {
      // value가 false이면 항상 false
      if (value == false) {
        setPushNotificationEnable(false);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      localPushService.requestPermissions().then((value) {
        setPushNotificationEnable(value!);
      });
    }
  }

  final localPushService = GetIt.I<LocalPushService>();

  bool? pushNotificationEnable;

  get isPushNotificationEnable => pushNotificationEnable;

  void setPushNotificationEnable(bool value) {
    pushNotificationEnable = value;
    Hive.box(hivePrefBox).put('pushNotificationEnable', value);
    notifyListeners();
  }

  Future<bool?> checkPermission() async {
    return localPushService.requestPermissions();
  }
}
