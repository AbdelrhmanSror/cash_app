import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functional/ArchiveButtonWidget.dart';
import 'package:debts_app/widgets/functional/CashInButtonWidget.dart';
import 'package:debts_app/widgets/functional/CashOutButtonWidget.dart';
import 'package:debts_app/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/widgets/functional/OperationsArchiveWidget.dart';
import 'package:debts_app/widgets/screens/ListDetailScreen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'CashScreen.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({Key? key}) : super(key: key);

  @override
  State<CashBookScreen> createState() {
    return _CashBookScreenState();
  }
}

class _CashBookScreenState extends State<CashBookScreen>
    with AppDatabaseListener {
  List<AppModel>? _models;

  @override
  void initState() {
    super.initState();
    //register this widget as listener to the any updates happen in the database
    database.registerListener(this);
    //retrieve all the data in the database to initialize our app
    database.retrieveAll();
  }

  void deleteAll() {
    database.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    print('BUIDLing cash book screen');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        title: const Text(
          'DEBTS',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Column(children: [
            buildInOutCashDetails(),
            const Divider(
              thickness: 0.5,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 8, bottom: 16),
                  child: Row(
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
    );
  }

  CashOutButton buildCashOutButton(BuildContext context) {
    return CashOutButton(onCashOutPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CashOutScreen()),
      );
    });
  }

  CashInButton buildCashInButton(BuildContext context) {
    return CashInButton(onCashInPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CashInScreen()),
      );
    });
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        models: _models,
        onPressed: (model) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListDetailScreen(model: model)),
          );
        });
  }

  ArchiveButtonWidget buildArchiveButtonWidget() =>
      ArchiveButtonWidget(onPressed: () => deleteAll());

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: Utility.getSize(_models));
  }

  OperationsArchiveWidget buildOperationsArchiveWidget() =>
      OperationsArchiveWidget(onPressed: () {});

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: _models == null ? 0 : _models![0].getBalance(),
    );
  }

  InOutCashDetails buildInOutCashDetails() => InOutCashDetails(models: _models);

  @override
  void onInsertDatabase(AppModel model) {
    print('insertion cash book screen');
    if (!mounted) return;
    setState(() {
      if (_models == null || _models![0] is EmptyAppModel) {
        _models = [];
      }
      _models!.insert(0, model);
    });
  }

  @override
  void onStartDatabase(List<AppModel> models) {
    print('start cash book screen');
    if (!mounted) return;
    setState(() {
      //initial setup for models
      _models = models;
    });
  }

  @override
  void onDeleteAllDatabase(AppModel model) {
    if (!mounted) return;
    setState(() {
      //we delete all the data and insert empty model in the beginning to show database is empty
      _models!.clear();
      _models!.add(EmptyAppModel());
    });
  }

  @override
  void onLoadingDatabase(bool active) {}

  @override
  void onDeleteDatabase(int id) {
    if (!mounted) return;
    setState(() {
      for (int index = 0; index < _models!.length; index++) {
        if (_models![index].id == id) {
          _models!.removeAt(index);
          return;
        }
      }
    });
  }

  @override
  void onUpdateDatabase(AppModel model) {
    // TODO: implement onUpdateDatabase
  }
}
