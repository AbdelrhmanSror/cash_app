import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/ArchiveModel.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:debts_app/utility/Extensions.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'ListDetailScreen.dart';

class OperationArchiveScreen extends StatefulWidget {
  const OperationArchiveScreen({Key? key, required this.parentId})
      : super(key: key);
  final int parentId;

  @override
  State<OperationArchiveScreen> createState() => _OperationArchiveScreenState();
}

class _OperationArchiveScreenState extends State<OperationArchiveScreen>
    implements ArchiveDatabaseListener<CashBookModel> {
  List<CashBookModel> models = [];

  @override
  void initState() {
    super.initState();
    databaseRepository.registerArchiveCashBookDatabaseListener(this);
    databaseRepository.retrieveArchivedCashBooks(widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
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
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AppTextWithDot(
                        text: 'Starting date',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      AppTextWithDot(
                        text: models.isNotEmpty
                            ? models[models.length - 1]
                                .date
                                .getFormattedDateTime2()
                            : '',
                        color: Colors.blueGrey.shade300,
                        fontSize: 12,
                      )
                    ]),
                Icon(Icons.arrow_forward, size: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppTextWithDot(
                      text: 'Closing date',
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    AppTextWithDot(
                      text: models.isNotEmpty
                          ? models[models.length - 1]
                              .date
                              .getFormattedDateTime2()
                          : '',
                      color: Colors.blueGrey.shade300,
                      fontSize: 12,
                    )
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        models: models,
        onPressed: (model) {
          Navigator.of(context).push(Utility.createAnimationRoute(
              ListDetailScreen(
                  model: model, hideEditButton: true, hideDeleteButton: true),
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

  int getIndex(ArchivedModel model) {
    var index = 0;
    for (int i = 0; i < models.length; i++) {
      if (model.id == models[i].id) {
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
      this.models = models;
    });
  }
}
