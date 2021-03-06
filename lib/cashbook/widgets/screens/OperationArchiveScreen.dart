import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/RectangleTitleArea.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
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
  CashBookModelListDetails models = CashBookModelListDetails([]);
  bool isLoading = true;

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
        body: buildWidget(context));
  }

  Widget buildWidget(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        RectangleTitleArea(
          radius: 20,
          title1: const AppTextWithDot(
            text: 'Starting date',
            style: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subTitle1: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: AppTextWithDot(
              text: DateUtility.getDateRepresentation2(
                      DateTime.parse(models.startDate)) +
                  ' At ' +
                  DateUtility.getTimeRepresentation(
                      DateTime.parse(models.startDate)),
              style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 12),
            ),
          ),
          title2: const AppTextWithDot(
            text: 'Closing date',
            style: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subTitle2: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: AppTextWithDot(
              text: DateUtility.getDateRepresentation2(
                      DateTime.parse(models.endDate)) +
                  ' At ' +
                  DateUtility.getTimeRepresentation(
                      DateTime.parse(models.endDate)),
              style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 12),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Column(children: [
                Container(
                    alignment: Alignment.center,
                    child: buildInOutCashDetails()),
                const Divider(
                  thickness: 0.2,
                  color: Colors.blueGrey,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: buildNetBalanceWidget(),
                ),
              ]),
              Container(
                alignment: Alignment.bottomLeft,
                child: buildOperationNumberWidget(),
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 20, bottom: 2),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: buildOperationListWidget(context),
              ))
            ],
          ),
        )
      ]);
    }
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        slideable: false,
        itemComparator: (e1, e2) =>
            models.itemSortComparator(SortFilter.latest, e1, e2),
        groupBy: (element) => element.groupId,
        models: models.models,
        onItemPressed: (model) {
          Navigator.of(context).push(Utility.createAnimationRoute(
              ListDetailScreen(
                  model: model, hideEditButton: true, hideDeleteButton: true),
              const Offset(0.0, 1.0),
              Offset.zero,
              Curves.ease));
        });
  }

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: models.models.length);
  }

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: models.getBalance(),
    );
  }

  InOutCashDetails buildInOutCashDetails() => InOutCashDetails(models: models);

  @override
  void onDatabaseStarted(CashBookModelListDetails models) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
      this.models = models;
    });
  }
}
