import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';

final AutoDisposeChangeNotifierProvider<PushNotificationState>
    pushNotificationProvider = ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<PushNotificationState> ref) {
  return PushNotificationState();
});

class PushNotificationState extends ChangeNotifier {
  PushNotificationState() {
    pushNotificationEnable = Hive.box(hivePrefBox)
        .get('pushNotificationEnable', defaultValue: true) as bool;
  }

  bool? pushNotificationEnable;

  get isPushNotificationEnable => pushNotificationEnable;

  void setPushNotificationEnable(bool value) {
    pushNotificationEnable = value;
    Hive.box(hivePrefBox).put('pushNotificationEnable', value);
    notifyListeners();
  }
}
