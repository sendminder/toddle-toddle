import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:toddle_toddle/states/bottom_nav_bar_state.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? navIndex = ref.watch(bottomNavProvider) as int?;

    return Card(
      margin: const EdgeInsets.only(top: 1, right: 4, left: 4),
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.shadow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 3,
            thickness: 0.2,
            indent: 5,
            endIndent: 5,
            color: Colors.grey,
          ),
          BottomNavigationBar(
            enableFeedback: false,
            currentIndex: navIndex ?? 0,
            onTap: (int index) {
              ref.read(bottomNavProvider.notifier).setAndPersistValue(index);
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).textTheme.bodySmall!.color,
            selectedFontSize: 12,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
            unselectedFontSize: 12,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(FluentIcons.run_24_regular),
                label: tr('bottom_nav_first'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(FluentIcons.history_24_regular),
                label: tr('bottom_nav_second'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(FluentIcons.settings_24_regular),
                label: tr('bottom_nav_third'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
