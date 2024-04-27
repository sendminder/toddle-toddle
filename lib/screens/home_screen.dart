import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:toddle_toddle/widgets/bottom_nav_bar.dart';
import 'package:toddle_toddle/states/bottom_nav_bar_state.dart';
import 'check_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? navIndex = ref.watch(bottomNavProvider) as int?;
    const List<Widget> pageNavigation = <Widget>[
      CheckScreen(),
      StatisticsScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: pageNavigation.elementAt(navIndex ?? 0),
      bottomNavigationBar: const BottomNavBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
