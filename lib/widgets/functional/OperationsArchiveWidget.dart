import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        paddingBottom: 5,
        paddingLeft: 60,
        paddingRight: 60,
        paddingTop: 5,
        onPressed: onPressed,
        radius: 50,
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor);
  }
}
