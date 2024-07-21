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

class PushNotificationState extends ChangeNotifier {
  PushNotificationState() {
    pushNotificationEnable = Hive.box(hivePrefBox)
        .get('pushNotificationEnable', defaultValue: true) as bool;
    checkPermission().then((value) {
      // value가 false이면 항상 false
      if (value == false) {
        setPushNotificationEnable(false);
      }
    });
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
