import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functional/ArchiveButtonWidget.dart';
import 'package:debts_app/widgets/functional/CashInButtonWidget.dart';
import 'package:debts_app/widgets/functional/CashOutButtonWidget.dart';
import 'package:debts_app/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/widgets/functional/OperationsArchiveWidget.dart';
import 'package:debts_app/widgets/screens/ArchiveModalSheetScreen.dart';
import 'package:debts_app/widgets/screens/ListDetailScreen.dart';
import 'package:debts_app/widgets/screens/OperationArchiveScreen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'CashScreen.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({required this.models, Key? key}) : super(key: key);
  final List<AppModel> models;

  @override
  State<CashBookScreen> createState() {
    return _CashBookScreenState();
  }
}

class _CashBookScreenState extends State<CashBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        setState(() {
          appDatabase.retrieveAll();
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            buildInOutCashDetails(),
            const Divider(
              thickness: 0.2,
              color: Colors.blueGrey,
              indent: 20,
              endIndent: 20,
            ),
            buildNetBalanceWidget(),
            Container(
                padding: const EdgeInsets.all(16.0),
                child: buildOperationsArchiveWidget())
          ]),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOperationNumberWidget(),
                        buildArchiveButtonWidget()
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
    ));
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
        models: widget.models,
        onPressed: (model) {
          Navigator.of(context).push(Utility.createAnimationRoute(
              ListDetailScreen(model: model),
              const Offset(0.0, 1.0),
              Offset.zero,
              Curves.ease));
        });
  }

  ArchiveButtonWidget buildArchiveButtonWidget() => ArchiveButtonWidget(
      onPressed: () {
        Utility.createModalSheet(
            context, ArchiveModalSheetScreen(models: widget.models));
      },
      hide: (widget.models.isEmpty));

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: widget.models.length);
  }

  OperationsArchiveWidget buildOperationsArchiveWidget() =>
      OperationsArchiveWidget(onPressed: () {
        Navigator.of(context).push(Utility.createAnimationRoute(
            OperationArchiveScreen(models: widget.models),
            const Offset(0.0, 1.0),
            Offset.zero,
            Curves.ease));
      });

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: widget.models.isEmpty ? 0 : widget.models[0].getBalance(),
    );
  }

  InOutCashDetails buildInOutCashDetails() =>
      InOutCashDetails(models: widget.models);
}
