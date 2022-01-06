import 'package:flutter/material.dart';

class AppTextWithDot extends StatelessWidget {
  AppTextWithDot(
      {required this.text,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 10,
      required this.color,
      Key? key})
      : super(key: key);
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: TextStyle(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}
