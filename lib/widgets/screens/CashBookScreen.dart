import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functionalWidgets/ArchiveButtonWidget.dart';
import 'package:debts_app/widgets/functionalWidgets/CashInButtonWidget.dart';
import 'package:debts_app/widgets/functionalWidgets/CashOutButtonWidget.dart';
import 'package:debts_app/widgets/functionalWidgets/InOutCashDetails.dart';
import 'package:debts_app/widgets/functionalWidgets/NetBalanceWidget.dart';
import 'package:debts_app/widgets/functionalWidgets/OperationListWidget.dart';
import 'package:debts_app/widgets/functionalWidgets/OperationNumberWidget.dart';
import 'package:debts_app/widgets/functionalWidgets/OperationsArchiveWidget.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class CashBookScreen extends StatefulWidget {
  CashBookScreen({Key? key}) : super(key: key);

  //late _CashBookScreenState cashBookScreenState;
  @override
  State<CashBookScreen> createState() {
    return _CashBookScreenState();
  }
}

class _CashBookScreenState extends State<CashBookScreen>
    with AppDatabaseListener {
  List<AppModel> models = [EmptyAppModel()];

  void insert() {
    database.insert(
      AppModel(date: Utility.getTimeNow(), cash: 50000, type: CASH_IN),
    );
  }

  void insert2() async {
    database.insert(
      AppModel(date: Utility.getTimeNow(), cash: 5000, type: CASH_OUT),
    );
  }

  void deleteAll() {
    database.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    print('building the cash book screen ${models}');
    // super.build(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            InOutCashDetails(models: models),
            const Divider(
              thickness: 0.5,
              color: Colors.blueGrey,
              indent: 20,
              endIndent: 20,
            ),
            NetBalanceWidget(
              models: models,
            ),
          ]),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OperationsArchiveWidget(onPressed: () {}),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OperationNumberWidget(
                          countNumber: Utility.getSize(models)),
                      ArchiveButtonWidget(onPressed: () => deleteAll())
                    ]),
              ),
              OperationListWidget(models: models, height: 200),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CashInButton(onCashInPressed: () => insert()),
                  const SizedBox(width: 16), // give it width
                  CashOutButton(onCashOutPressed: () => insert2())
                ],
              ),
              const SizedBox(height: 15),
            ],
          )
        ],
      ),
    );
  }

  @override
  void onInsertionDatabase(AppModel model) {
    setState(() {
      //in case if there was empty model at the beginning of the list
      if (models[0] is EmptyAppModel) models.removeAt(0);
      models.insert(0, model);
    });
  }

  @override
  void onStartDatabase(List<AppModel> models) {
    setState(() {
      //initial setup for models
      this.models = models;
    });
  }

  @override
  void initState() {
    super.initState();
    //register this widget as listener to the any updates happen in the database
    database.registerListener(this);
    //retrieve all the data in the database to initialize our app
    database.retrieveAll();
  }

  @override
  void onDeletionDatabase(AppModel model) {
    setState(() {
      //we delete all the data and insert empty model in the beginning to reflect on our ui
      models.clear();
      models.add(EmptyAppModel());
    });
  }

  @override
  void onLoadingDatabase(bool active) {}

/*@override
  bool get wantKeepAlive => true;*/
}
