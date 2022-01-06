import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../partialWidgets/AppTextWithDots.dart';
import '../partialWidgets/RoundedButton.dart';

class CashOutButton extends StatelessWidget {
  const CashOutButton({required this.onCashOutPressed, Key? key})
      : super(key: key);

  final Function() onCashOutPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: AppTextWithDot(
          text: '- CASH OUT',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.red),
      backgroundColor: const Color(0xCCFDF1F3),
      radius: 5.0,
      padding_top: 20,
      padding_bottom: 20,
      padding_left: 40,
      padding_right: 40,
      onPressed: () => onCashOutPressed(),
    );
  }
}
