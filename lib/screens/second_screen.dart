import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:toddle_toddle/widgets/header.dart';
import 'package:toddle_toddle/widgets/theme_card.dart';
import 'package:toddle_toddle/widgets/link_card.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const Header(text: 'bottom_nav_second'),
          Card(
            elevation: 2,
            shadowColor: Theme.of(context).colorScheme.shadow,

            /// Example: Many items have their own colors inside of the ThemData
            /// You can overwrite them in [config/theme.dart].
            color: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: SwitchListTile(
              onChanged: (bool newValue) {
                /// Example: Change locale
                /// The initial locale is automatically determined by the library.
                /// Changing the locale like this will persist the selected locale.
                context.setLocale(
                    newValue ? const Locale('ko') : const Locale('en'));
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              value: context.locale == const Locale('ko'),

              /// You can use a FittedBox to keep Text in its bounds.
              title: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Row(
                  children: <Widget>[
                    Icon(
                      FluentIcons.local_language_24_regular,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      tr('language_switch_title'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(fontWeightDelta: 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.75 / 1,
              padding: EdgeInsets.zero,
              children: const <ThemeCard>[
                ThemeCard(
                  mode: ThemeMode.system,
                  icon: FluentIcons.dark_theme_24_regular,
                ),
                ThemeCard(
                  mode: ThemeMode.light,
                  icon: FluentIcons.weather_sunny_24_regular,
                ),
                ThemeCard(
                  mode: ThemeMode.dark,
                  icon: FluentIcons.weather_moon_24_regular,
                ),
              ]),

          /// Example: Good way to add space between items without using Paddings
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Divider(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(.2),
            ),
          ),
          LinkCard(
            title: 'github_card_title',
            icon: FluentIcons.diversity_24_regular,
            url: Uri.parse(
                'https://github.com/anfeichtinger/flutter_production_boilerplate_riverpod'),
          ),
        ],
      ),
    );
  }
}
