import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/widgets/partialWidgets/CompositeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../partialWidgets/AppTextWithDots.dart';

class InOutCashDetails extends StatelessWidget {
  const InOutCashDetails({required this.models, Key? key}) : super(key: key);
  final List<AppModel>? models;

  @override
  Widget build(BuildContext context) {
    //getting the latest row in the table to get the recent info.
    final double totalCashIn =
        (models != null && models!.isNotEmpty) ? models![0].totalCashIn : 0;
    final double totalCashOut =
        (models != null && models!.isNotEmpty) ? models![0].totalCashOut : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CompositeWidget(
          width: 150,
          widgets: [
            AppTextWithDot(
              text: 'Cash in',
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            AppTextWithDot(
              text: '${totalCashIn} EGP',
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
          vertical: true,
        ),
        const SizedBox(
          height: 80,
          child: VerticalDivider(
            color: Colors.grey,
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
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            AppTextWithDot(
              text: '${totalCashOut} EGP',
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
