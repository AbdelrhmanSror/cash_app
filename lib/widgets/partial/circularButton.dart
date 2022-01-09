import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({required this.icon, Key? key}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: Icon(icon, size: 20, color: const Color(0xFF281361)),
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
    );
  }
}
