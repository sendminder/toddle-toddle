import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toddle_toddle/const/strings.dart';

final AutoDisposeStateNotifierProvider<BottomNavBarState, Object?>
    bottomNavProvider = StateNotifierProvider.autoDispose(
        (AutoDisposeStateNotifierProviderRef<BottomNavBarState, Object?> ref) {
  return BottomNavBarState(0);
});

class BottomNavBarState extends StateNotifier<int> {
  BottomNavBarState(super.state) {
    value = Hive.box(hivePrefBox).get('navIndex', defaultValue: state) as int;
  }

  set value(int index) => state = index;

  int get value => state;

  void setAndPersistValue(int index) {
    value = index;
    if (index != 2) {
      // 설정탭은 저장안함
      Hive.box(hivePrefBox).put('navIndex', index);
    }
  }
}
