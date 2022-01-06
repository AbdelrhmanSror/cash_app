import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../partialWidgets/AppTextWithDots.dart';
import '../partialWidgets/RoundedButton.dart';

class CashInButton extends StatelessWidget {
  const CashInButton({required this.onCashInPressed, Key? key})
      : super(key: key);

  final Function() onCashInPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: AppTextWithDot(
          text: '+ CASH IN',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.green),
      backgroundColor: const Color(0xF5C0F8B2),
      radius: 5.0,
      padding_top: 20,
      padding_bottom: 20,
      padding_left: 40,
      padding_right: 40,
      onPressed: () => onCashInPressed(),
    );
  }
}
