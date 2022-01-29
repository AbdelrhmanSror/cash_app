import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
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
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3345A6)),
        ),
        const VerticalDivider(width: 2),
        AppTextWithDot(
          text: '(',
          style: Theme.of(context).textTheme.caption,
        ),
        AppTextWithDot(
          text: '$countNumber',
          style: Theme.of(context).textTheme.caption,
        ),
        AppTextWithDot(
          text: ')',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
