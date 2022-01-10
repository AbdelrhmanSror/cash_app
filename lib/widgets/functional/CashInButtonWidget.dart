import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

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
      paddingTop: 16,
      paddingBottom: 16,
      paddingLeft: 45,
      paddingRight: 45,
      onPressed: () => onCashInPressed(),
    );
  }
}
