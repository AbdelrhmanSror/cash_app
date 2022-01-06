import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/partialWidgets/AppTextWithDots.dart';
import 'package:debts_app/widgets/partialWidgets/CompositeTextWidget.dart';
import 'package:flutter/material.dart';

class NetBalanceWidget extends StatelessWidget {
  NetBalanceWidget({
    required this.models,
    Key? key,
  }) : super(key: key);
  final List<AppModel>? models;

  @override
  Widget build(BuildContext context) {
    final balance = Utility.getBalance(models![0]);
    return CompositeTextWidget(
      width: 150,
      texts: [
        AppTextWithDot(
          text: 'Net balance',
          color: const Color(0xFACDCACA),
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        AppTextWithDot(
          text: ' ${(balance).abs()} EGP',
          color: balance < 0 ? Colors.red : Colors.greenAccent,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        )
      ],
    );
  }
}
