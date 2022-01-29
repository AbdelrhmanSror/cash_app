import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/ArchiveButtonWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/CashInButtonWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/CashOutButtonWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationsArchiveWidget.dart';
import 'package:debts_app/cashbook/widgets/screens/CashBookScreen.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'ArchiveModalSheetScreen.dart';
import 'CashScreen.dart';
import 'ListDetailScreen.dart';
import 'OperationArchiveParentListScreen.dart';
import 'OperationArchiveScreen.dart';

class CashListScreen extends StatefulWidget {
  const CashListScreen({Key? key}) : super(key: key);

  @override
  State<CashListScreen> createState() {
    return _CashListScreenState();
  }
}

class _CashListScreenState extends State<CashListScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  CashBookModelListDetails models = CashBookModelListDetails([]);
  bool _isLoading = true;

  final List<bool> _typeOptionSelections = [true, false, false];
  int previousTypeSelectedOptionIndex = 0;
  SortFilter sortType = SortFilter.LATEST;

  DateFilter dateType = DateFilter.ALL;
  int previousDateSelectedOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              databaseRepository.retrieveCashBooks();
            },
            child: Scaffold(
                backgroundColor: Theme.of(context).canvasColor,
                appBar: MyCustomAppBar(
                  title: const Text(
                    'DEBTS',
                    style: TextStyle(
                        color: Color(0xFF3345A6),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Column(
                    children: [
                      buildTypeFilter(),
                      Expanded(child: buildOperationListWidget(context)),
                      buildCashInOutButton(context)
                    ],
                  ),
                )));
  }

  Container buildCashInOutButton(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          minWidth: double.infinity, maxWidth: double.infinity),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: buildCashInButton(context)),
          const VerticalDivider(),
          Expanded(child: buildCashOutButton(context))
        ],
      ),
    );
  }

  Widget buildTypeFilter() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: buildChoiceChip(
            _typeOptionSelections[0],
            'All',
            (value) async {
              showLoadingBar();
              await databaseRepository.setTypeInPreferences(TypeFilter.ALL);
              databaseRepository.retrieveFilteredCashBooks();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: buildChoiceChip(
            _typeOptionSelections[1],
            'Income',
            (value) async {
              showLoadingBar();
              await databaseRepository.setTypeInPreferences(TypeFilter.CASH_IN);
              databaseRepository.retrieveFilteredCashBooks();
            },
          ),
        ),
        buildChoiceChip(
          _typeOptionSelections[2],
          'Outcome',
          (value) async {
            showLoadingBar();
            await databaseRepository.setTypeInPreferences(TypeFilter.CASH_OUT);
            databaseRepository.retrieveFilteredCashBooks();
          },
        ),
      ],
    );
  }

  CashOutButton buildCashOutButton(BuildContext context) {
    return CashOutButton(onCashOutPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          const CashOutScreen(operationType: OperationType.INSERT),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  CashInButton buildCashInButton(BuildContext context) {
    return CashInButton(onCashInPressed: () {
      Navigator.of(context).push(Utility.createAnimationRoute(
          const CashInScreen(operationType: OperationType.INSERT),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    });
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        models: models.models,
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
      hide: (models.models.isEmpty));

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: models.models.length);
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
      netBalance:
          models.models.isEmpty ? 0 : models.totalCashIn - models.totalCashOut,
    );
  }

  Widget buildInOutCashDetails() => InOutCashDetails(models: models);

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
  void onDatabaseChanged(CashBookModelListDetails insertedModels) async {
    if (!mounted) return;

    updateTypeFilter(await databaseRepository.getTypesFromPreferences());
    sortType = await databaseRepository.getSortFromPreferences();
    setState(() {
      //to dismiss loading bar
      if (_isLoading) {
        dismissLoadingBar();
      }
      models = insertedModels;
    });
    // });
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;
    updateTypeFilter(await databaseRepository.getTypesFromPreferences());
    sortType = await databaseRepository.getSortFromPreferences();
    setState(() {
      _isLoading = false;
      //initial setup for models
      this.models = models;
    });
  }

  Widget buildChoiceChip(
      bool selected, String text, Function(bool) onSelected) {
    return ChoiceChip(
      selected: selected,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: selected ? const Color(0xFF3345A6) : Colors.grey.shade50,
            width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white10,
      label: Text(
        text,
        style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500),
      ),
      selectedColor: const Color(0xFF3345A6),
      onSelected: (bool value) {
        onSelected(value);
      },
    );
  }

  void updateTypeFilter(TypeFilter type) {
    _typeOptionSelections[previousTypeSelectedOptionIndex] = false;
    if (type == TypeFilter.CASH_IN) {
      _typeOptionSelections[1] = true;
      previousTypeSelectedOptionIndex = 1;
      return;
    }
    if (type == TypeFilter.CASH_OUT) {
      _typeOptionSelections[2] = true;
      previousTypeSelectedOptionIndex = 2;
      return;
    }
    _typeOptionSelections[0] = true;
    previousTypeSelectedOptionIndex = 0;
  }

  void dismissLoadingBar() {
    _isLoading = false;
    Navigator.of(context).pop();
  }

  void showLoadingBar() {
    _isLoading = true;
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
      context: context,
    );
  }
}
