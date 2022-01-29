import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

class OperationsArchiveWidget extends StatelessWidget {
  const OperationsArchiveWidget({
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedTextButton(
        text: const AppTextWithDot(
          text: 'Operations archive',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3345A6),
          ),
        ),
        paddingBottom: 5,
        paddingLeft: 8,
        paddingRight: 8,
        paddingTop: 5,
        onPressed: onPressed,
        radius: 50,
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor);
  }
}
