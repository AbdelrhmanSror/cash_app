import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/CashBookDatabase.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
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

import 'CashScreen.dart';

final cashBookDatabase = CashBookDatabase();

class CashBookScreen extends StatefulWidget {
  CashBookScreen({Key? key}) : super(key: key);
  List<CashBookModel> _models = [];

  @override
  State<CashBookScreen> createState() {
    return _CashBookScreenState();
  }
}

class _CashBookScreenState extends State<CashBookScreen>
    with AppDatabaseListener<CashBookModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        setState(() {
          cashBookDatabase.retrieveAll();
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
          CashOutScreen(operationType: INSERT, database: cashBookDatabase),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  CashInButton buildCashInButton(BuildContext context) {
    return CashInButton(onCashInPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          CashInScreen(operationType: INSERT, database: cashBookDatabase),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        models: widget._models,
        onPressed: (model) {
          Navigator.of(context).push(Utility.createAnimationRoute(
              ListDetailScreen(model: model, database: cashBookDatabase),
              const Offset(0.0, 1.0),
              Offset.zero,
              Curves.ease));
        });
  }

  ArchiveButtonWidget buildArchiveButtonWidget() => ArchiveButtonWidget(
      onPressed: () {
        Utility.createModalSheet(
            context, ArchiveModalSheetScreen(models: widget._models));
      },
      hide: (widget._models.isEmpty));

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: widget._models.length);
  }

  OperationsArchiveWidget buildOperationsArchiveWidget() =>
      OperationsArchiveWidget(onPressed: () {
        Navigator.of(context).push(Utility.createAnimationRoute(
            OperationArchiveScreen(parentId: 1),
            const Offset(0.0, 1.0),
            Offset.zero,
            Curves.ease));
      });

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: widget._models.isEmpty ? 0 : widget._models[0].getBalance(),
    );
  }

  InOutCashDetails buildInOutCashDetails() =>
      InOutCashDetails(models: widget._models);

  @override
  void initState() {
    super.initState();
    //register this widget as listener to the any updates happen in the database
    cashBookDatabase.registerListener(this);
    //retrieve all the data in the database to initialize our app
    cashBookDatabase.retrieveAll();
  }

  @override
  void onInsertDatabase(List<CashBookModel> insertedModels) {
    if (!mounted) return;
    setState(() {
      for (var model in insertedModels) {
        widget._models.insert(0, model);
      }
    });
  }

  @override
  void onStartDatabase(List<CashBookModel> models) {
/*
    print('start cash book screen');
*/
    if (!mounted) return;
    setState(() {
      //initial setup for models
      widget._models = models;
    });
  }

  @override
  void onDeleteAllDatabase(List<CashBookModel> deletedModels) {
    if (!mounted) return;
    setState(() {
      widget._models = deletedModels;
    });
  }

  @override
  void onLastRowDeleted() {
    if (!mounted) return;
    setState(() {
      //remove last value in the list
      //we remove last value by first index because we retrieve all value from database in descending order
      widget._models.removeAt(0);
    });
  }

  @override
  void onUpdateAllDatabase(List<CashBookModel> updatedModels) {
    if (!mounted) return;
    setState(() {
      widget._models = updatedModels;
    });
  }

  @override
  void onUpdateDatabase(CashBookModel model) {
    if (!mounted) return;
    setState(() {
      widget._models[getIndex(model)] = model;
    });
  }

  int getIndex(CashBookModel model) {
    var index = 0;
    for (int i = 0; i < widget._models.length; i++) {
      if (model.id == widget._models[i].id) {
        index = i;
        break;
      }
    }
    return index;
  }
}
