import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.textSize = 16.0,
    this.style,
  });

  final String text;
  final double textSize;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    TextStyle effectiveStyle =
        Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: textSize);
    effectiveStyle = effectiveStyle.merge(style);

    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, top: 0, bottom: 0),
      child: Text(
        text.tr(),
        textAlign: TextAlign.left,
        style: effectiveStyle,
      ),
    );
  }
}
