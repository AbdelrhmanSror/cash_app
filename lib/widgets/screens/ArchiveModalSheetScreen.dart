import 'package:debts_app/utility/Extensions.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:debts_app/widgets/screens/ClosedBookAlertScreen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ArchiveModalSheetScreen extends StatelessWidget {
  const ArchiveModalSheetScreen({required this.models, Key? key})
      : super(key: key);

  final CashBookModelListDetails models;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.clear, color: Colors.blue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: const IconThemeData(
            color: Colors.blue,
          ),
          title: const Text(
            'CLOSE BOOK',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildInOutCashDetails(),
            const Divider(
              thickness: 0.5,
              color: Colors.blueGrey,
              indent: 20,
              endIndent: 20,
            ),
            buildNetBalanceWidget(),
            //              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppTextWithDot(
                            text: 'Starting date',
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          AppTextWithDot(
                            text: models.startDate.getFormattedDate(),
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ]),
                  ),
                  const Divider(height: 1, color: Colors.blueGrey),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppTextWithDot(
                            text: 'Closing date',
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          AppTextWithDot(
                            text: models.endDate.getFormattedDate(),
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ]),
                  ),
                  const Divider(height: 1, color: Colors.blueGrey),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppTextWithDot(
                            text: 'Number of operations',
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          AppTextWithDot(
                            text: '${models.models.length}',
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ]),
                  ),
                  const Divider(height: 1, color: Colors.blueGrey),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                        minWidth: double.infinity, maxWidth: double.infinity),
                    child: const AppTextWithDot(
                      text:
                          'You can still access your Cashbook in Operations archive',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                        minWidth: double.infinity, maxWidth: double.infinity),
                    child: RoundedTextButton(
                      text: const AppTextWithDot(
                          text: 'CLOSE BOOK',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.white),
                      backgroundColor: Colors.redAccent,
                      radius: 5.0,
                      paddingTop: 16,
                      paddingBottom: 16,
                      paddingLeft: 16,
                      paddingRight: 16,
                      onPressed: () {
                        databaseRepository.archiveCashBooks(models);
                        Utility.createModalSheet(
                                context, const ClosedBookAlertScreen())
                            .then((value) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                ]),
              ),
            )
          ],
        ));
  }

  InOutCashDetails buildInOutCashDetails() => InOutCashDetails(models: models);

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: models.getBalance(),
    );
  }
}
