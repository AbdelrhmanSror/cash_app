import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

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
      paddingTop: 20,
      paddingBottom: 20,
      paddingLeft: 40,
      paddingRight: 40,
      onPressed: () => onCashOutPressed(),
    );
  }
}