import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:flutter/material.dart';

class OperationsArchiveWidget extends StatelessWidget {
  const OperationsArchiveWidget({
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).canvasColor),
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.fromLTRB(60, 5, 60, 5))),
      onPressed: onPressed,
      child: AppTextWithDot(
        text: 'Operations archive',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}
