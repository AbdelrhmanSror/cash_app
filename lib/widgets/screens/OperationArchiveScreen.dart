import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functional/CashInButtonWidget.dart';
import 'package:debts_app/widgets/functional/CashOutButtonWidget.dart';
import 'package:debts_app/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:flutter/material.dart';

import 'CashScreen.dart';
import 'ListDetailScreen.dart';

class OperationArchiveScreen extends StatelessWidget {
  const OperationArchiveScreen({required this.models, Key? key})
      : super(key: key);
  final List<AppModel> models;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.blue, //change your color here
          ),
          title: const Text(
            'OPERATIONS ARCHIVE',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Column(children: [
          Container(
            margin:
                const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 16),
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppTextWithDot(
                          text: 'Starting date', color: Colors.black),
                      AppTextWithDot(
                          text: '09/01/2022 at 23:48',
                          color: Colors.blueGrey.shade200)
                    ]),
                Icon(Icons.double_arrow_sharp, color: Colors.blueGrey.shade200),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTextWithDot(text: 'Closing date', color: Colors.black),
                    AppTextWithDot(
                        text: '09/01/2022 at 23:48',
                        color: Colors.blueGrey.shade200)
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Column(children: [
                  buildInOutCashDetails(),
                  const Divider(
                    thickness: 0.2,
                    color: Colors.blueGrey,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: buildNetBalanceWidget(),
                  ),
                ]),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 20, bottom: 2),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildOperationNumberWidget(),
                            ]),
                      ),
                      Expanded(child: buildOperationListWidget(context)),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 32),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            buildCashInButton(context),
                            buildCashOutButton(context)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }

  CashOutButton buildCashOutButton(BuildContext context) {
    return CashOutButton(onCashOutPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          CashOutScreen(operationType: INSERT),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  CashInButton buildCashInButton(BuildContext context) {
    return CashInButton(onCashInPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          CashInScreen(operationType: INSERT),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        models: models,
        onPressed: (model) {
          Navigator.of(context).push(Utility.createAnimationRoute(
              ListDetailScreen(model: model),
              const Offset(0.0, 1.0),
              Offset.zero,
              Curves.ease));
        });
  }

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: models.length);
  }

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: models.isEmpty ? 0 : models[0].getBalance(),
    );
  }

  InOutCashDetails buildInOutCashDetails() => InOutCashDetails(models: models);
}
