import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:flutter/material.dart';

class NetBalanceWidget extends StatelessWidget {
  const NetBalanceWidget({
    required this.netBalance,
    Key? key,
  }) : super(key: key);
  final double netBalance;

  @override
  Widget build(BuildContext context) {
    return CompositeWidget(
      width: 250,
      widgets: [
        AppTextWithDot(
          text: 'Net balance',
          color: Color(0xFACDCACA),
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        AppTextWithDot(
          text: ' ${(netBalance).abs()} EGP',
          color: netBalance < 0 ? Colors.red : Colors.greenAccent,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        )
      ],
    );
  }
}
