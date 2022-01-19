import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:flutter/material.dart';

class InOutCashDetails extends StatelessWidget {
  const InOutCashDetails({required this.models, Key? key}) : super(key: key);
  final CashBookModelListDetails models;

  @override
  Widget build(BuildContext context) {
    //getting the latest row in the table to get the recent info.
    final double totalCashIn = models.totalCashIn;
    final double totalCashOut = models.totalCashOut;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CompositeWidget(
          width: 150,
          widgets: [
            AppTextWithDot(
              text: 'Cash in',
              color: Colors.blueGrey.shade200,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            AppTextWithDot(
              text: '$totalCashIn EGP',
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
          vertical: true,
        ),
        SizedBox(
          height: 80,
          child: VerticalDivider(
            color: Colors.blueGrey.shade200,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
        ),
        CompositeWidget(
          width: 200,
          widgets: [
            AppTextWithDot(
              text: 'Cash out',
              color: Colors.blueGrey.shade200,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            AppTextWithDot(
              text: '$totalCashOut EGP',
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
          vertical: true,
        )
      ],
    );
  }
}
