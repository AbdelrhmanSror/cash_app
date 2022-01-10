import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:flutter/material.dart';

class OperationNumberWidget extends StatelessWidget {
  const OperationNumberWidget({
    required this.countNumber,
    Key? key,
  }) : super(key: key);
  final int countNumber;

  @override
  Widget build(BuildContext context) {
    return CompositeWidget(
      width: 150,
      widgets: [
        AppTextWithDot(
            text: 'Operations',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blue),
        const VerticalDivider(width: 2),
        AppTextWithDot(
            text: '(',
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.blueGrey.shade200),
        AppTextWithDot(
            text: '$countNumber',
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.blueGrey.shade200),
        AppTextWithDot(
            text: ')',
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.blueGrey.shade200),
      ],
    );
  }
}
