import 'package:debts_app/widgets/partialWidgets/AppTextWithDots.dart';
import 'package:debts_app/widgets/partialWidgets/CompositeTextWidget.dart';
import 'package:flutter/material.dart';

class OperationNumberWidget extends StatelessWidget {
  OperationNumberWidget({
    required this.countNumber,
    Key? key,
  }) : super(key: key);
  final int countNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CompositeTextWidget(
        width: 150,
        texts: [
          AppTextWithDot(
              text: 'Operations',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue),
          VerticalDivider(width: 2),
          AppTextWithDot(
              text: '(',
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Color(0xFACDCACA)),
          AppTextWithDot(
              text: '$countNumber',
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Color(0xFACDCACA)),
          AppTextWithDot(
              text: ')',
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Color(0xFACDCACA)),
        ],
      ),
    );
  }
}
