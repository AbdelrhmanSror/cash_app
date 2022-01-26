import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

class CashOutButton extends StatelessWidget {
  const CashOutButton({required this.onCashOutPressed, Key? key})
      : super(key: key);

  final Function() onCashOutPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedTextButton(
      text: const AppTextWithDot(
        text: '- CASH OUT',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
      ),
      backgroundColor: const Color(0xCCFDF1F3),
      radius: 5.0,
      paddingTop: 16,
      paddingBottom: 16,
      paddingLeft: 45,
      paddingRight: 45,
      onPressed: () => onCashOutPressed(),
    );
  }
}
