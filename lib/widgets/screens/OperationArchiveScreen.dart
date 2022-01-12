import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/ArchiveModel.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:flutter/material.dart';

import 'ListDetailScreen.dart';

class OperationArchiveScreen extends StatefulWidget {
  OperationArchiveScreen({Key? key, required this.parentId}) : super(key: key);
  List<CashBookModel> _models = [];
  final int parentId;

  @override
  State<OperationArchiveScreen> createState() => _OperationArchiveScreenState();
}

class _OperationArchiveScreenState extends State<OperationArchiveScreen>
    implements ArchiveDatabaseListener<CashBookModel> {
  @override
  void initState() {
    super.initState();
    archiveDatabase.registerListener(this);
    archiveDatabase.retrieveAll(parentId: 2);
  }

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
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                archiveDatabase.retrieveAll();
              });
            },
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 4, right: 4, top: 16, bottom: 16),
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 16, right: 16),
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
                              text: widget._models.isNotEmpty
                                  ? widget._models[widget._models.length - 1]
                                  .getFormattedDate()
                                  : '',
                              color: Colors.blueGrey.shade200)
                        ]),
                    Icon(Icons.double_arrow_sharp,
                        color: Colors.blueGrey.shade200),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextWithDot(
                            text: 'Closing date', color: Colors.black),
                        AppTextWithDot(
                            text: widget._models.isNotEmpty
                                ? widget._models[widget._models.length - 1]
                                .getFormattedDate()
                                : '',
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  buildOperationNumberWidget(),
                                ]),
                          ),
                          Expanded(child: buildOperationListWidget(context)),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 8, bottom: 32),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ])));
  }

  /* CashOutButton buildCashOutButton(BuildContext context) {
    return CashOutButton(onCashOutPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          CashOutScreen(
              operationType: INSERT,
              database: archiveDatabase,
              parentId: widget.parentId),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }*/

/*
  CashInButton buildCashInButton(BuildContext context) {
    return CashInButton(onCashInPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          CashInScreen(
              operationType: INSERT,
              database: archiveDatabase,
              parentId: widget.parentId),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }
*/

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        models: widget._models,
        onPressed: (model) {
          Navigator.of(context).push(Utility.createAnimationRoute(
              ListDetailScreen(model: model),
              const Offset(0.0, 1.0),
              Offset.zero,
              Curves.ease));
        });
  }

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: widget._models.length);
  }

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: widget._models.isEmpty ? 0 : widget._models[0].getBalance(),
    );
  }

  InOutCashDetails buildInOutCashDetails() =>
      InOutCashDetails(models: widget._models);

  int getIndex(ArchivedModel model) {
    var index = 0;
    for (int i = 0; i < widget._models.length; i++) {
      if (model.id == widget._models[i].id) {
        index = i;
        break;
      }
    }
    return index;
  }

  @override
  void onRetrieveDatabase(List<CashBookModel> models) {
    if (!mounted) return;
    setState(() {
      widget._models = models;
    });
  }
}
