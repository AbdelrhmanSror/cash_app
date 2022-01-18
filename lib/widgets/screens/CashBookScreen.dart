import 'package:debts_app/database/AppDatabaseCallback.dart';
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
import 'package:debts_app/widgets/functional/SyncButton.dart';
import 'package:debts_app/widgets/screens/ArchiveModalSheetScreen.dart';
import 'package:debts_app/widgets/screens/ListDetailScreen.dart';
import 'package:debts_app/widgets/screens/OperationArchiveParentListScreen.dart';
import 'package:debts_app/widgets/screens/OperationArchiveScreen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'CashScreen.dart';
import 'FilterScreen.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({Key? key}) : super(key: key);

  @override
  State<CashBookScreen> createState() {
    return _CashBookScreenState();
  }
}

class _CashBookScreenState extends State<CashBookScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  List<CashBookModel> models = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: const Text(
            'DEBTS',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              databaseRepository.retrieveCashBooks();
            });
          },
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
                            Row(
                              children: [
                                buildOperationNumberWidget(),
                                SyncButton(
                                  onPressed: () async {
                                    databaseRepository.retrieveCashBooks();
                                  },
                                )
                              ],
                            ),
                            buildArchiveButtonWidget(),
                          ]),
                    ),
                    Expanded(child: buildOperationListWidget(context)),
                    Container(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity, maxWidth: double.infinity),
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(child: buildCashInButton(context)),
                          const VerticalDivider(),
                          Expanded(child: buildCashOutButton(context))
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
          const CashOutScreen(operationType: INSERT),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  CashInButton buildCashInButton(BuildContext context) {
    return CashInButton(onCashInPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          const CashInScreen(operationType: INSERT),
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

  ArchiveButtonWidget buildArchiveButtonWidget() => ArchiveButtonWidget(
      onPressed: () {
        Utility.createModalSheet(
            context, ArchiveModalSheetScreen(models: models));
      },
      hide: (models.isEmpty));

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: models.length);
  }

  OperationsArchiveWidget buildOperationsArchiveWidget() =>
      OperationsArchiveWidget(onPressed: () {
        Navigator.of(context).push(Utility.createAnimationRoute(
            OperationArchiveParentListScreen(onPressed: (parentId) {
              Navigator.of(context).push(Utility.createAnimationRoute(
                  OperationArchiveScreen(parentId: parentId),
              const Offset(1.0, 0.0),
              Offset.zero,
              Curves.ease));
        }), const Offset(0.0, 1.0), Offset.zero, Curves.ease));
      });

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: models.isEmpty ? 0 : models[0].getBalance(),
    );
  }

  Widget buildInOutCashDetails() => InkWell(
        onTap: () {
          Utility.createModalSheet(
              context,
              FilterScreen(
                onDateSelected: (startDate, endDate) {},
              ),
              enableDrag: false);
        },
        child: InOutCashDetails(
          models: models,
        ),
      );

  // Utility.createModalSheet(context, CashInFilterScreen());

  @override
  void initState() {
    super.initState();
    //register this widget as listener to the any updates happen in the database
    databaseRepository.registerCashBookDatabaseListener(this);
    //retrieve all the data in the database to initialize our app
    databaseRepository.retrieveCashBooks();
  }

  @override
  void onInsertDatabase(List<CashBookModel> insertedModels) {
    if (!mounted) return;
    setState(() {
      models = insertedModels;
    });
  }

  @override
  void onRetrieveDatabase(List<CashBookModel> models) {
/*
    print('start cash book screen');
*/
    if (!mounted) return;
    setState(() {
      //initial setup for models
      this.models = models;
    });
  }

  @override
  void onDeleteAllDatabase(List<CashBookModel> deletedModels) {
    if (!mounted) return;
    setState(() {
      models.clear();
    });
  }

  @override
  void onUpdateDatabase(List<CashBookModel> updatedModels) {
    if (!mounted) return;
    setState(() {
      models = updatedModels;
    });
  }

  int getIndex(CashBookModel model) {
    var index = 0;
    for (int i = 0; i < models.length; i++) {
      if (model.id == models[i].id) {
        index = i;
        break;
      }
    }
    return index;
  }
}
