import 'package:flutter/material.dart';

class AppTextWithDot extends StatelessWidget {
  const AppTextWithDot(
      {required this.text, required this.style, this.maxLines = 1, Key? key})
      : super(key: key);
  final String text;
  final TextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: style);
  }
}
