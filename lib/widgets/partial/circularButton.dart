import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({required this.icon, Key? key}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {},
      child: Icon(icon, size: 20, color: const Color(0xFF281361)),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const CircleBorder(),
          primary: Color(0xFFF0F6FC)),
    );
  }
}
