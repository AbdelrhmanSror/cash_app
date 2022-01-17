import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {required this.icon,
      this.iconColor = const Color(0xFF281361),
      this.backgroundColor = const Color(0xFFe0f2f1),
      Key? key})
      : super(key: key);
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: Icon(icon, size: 20, color: iconColor),
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
    );
  }
}
