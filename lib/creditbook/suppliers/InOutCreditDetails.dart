/*

import 'package:debts_app/cashbook/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/creditbook/suppliers/database/supplier.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";


class InOutCreditDetails extends StatelessWidget {
  const InOutCreditDetails({required this.suppliers, Key? key}) : super(key: key);
  final List<Supplier> suppliers;
  late double _cashGivenToSuppliers ;
  late double _cashCreditedFromSuppliers;

  void setUpCashFromToSuppliers(){
    for(var supplier in suppliers){
      if(supplier.balance>=0){


      }
    }
  }

  @override
  Widget build(BuildContext context) {


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
*/
