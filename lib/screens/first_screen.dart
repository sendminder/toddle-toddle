import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:toddle_toddle/widgets/info_card.dart';
import 'package:toddle_toddle/widgets/header.dart';

class FirstScreen extends ConsumerWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            const Header(text: 'app_name'),
            GridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 2,
                padding: EdgeInsets.zero,
                children: const <InfoCard>[
                  /// Example: it is good practice to put widgets in separate files.
                  /// This way the screen files won't become too large and
                  /// the code becomes more clear.
                  InfoCard(
                      title: 'localization_title',
                      content: 'localization_content',
                      icon: FluentIcons.local_language_24_regular,
                      isPrimaryColor: true),
                  InfoCard(
                      title: 'linting_title',
                      content: 'linting_content',
                      icon: FluentIcons.code_24_regular,
                      isPrimaryColor: false),
                  InfoCard(
                      title: 'storage_title',
                      content: 'storage_content',
                      icon: FluentIcons.folder_open_24_regular,
                      isPrimaryColor: false),
                ]),
          ]),
    );
  }
}
