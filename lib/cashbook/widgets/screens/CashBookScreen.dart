import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/FilterSharedPreferences.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/cashbook/widgets/functional/ArchiveButtonWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/CashInButtonWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/CashOutButtonWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/LineChart.dart';
import 'package:debts_app/cashbook/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationsArchiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'ArchiveModalSheetScreen.dart';
import 'CashScreen.dart';
import 'FilterScreen.dart';
import 'ListDetailScreen.dart';
import 'OperationArchiveParentListScreen.dart';
import 'OperationArchiveScreen.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({Key? key}) : super(key: key);

  @override
  State<CashBookScreen> createState() {
    return _CashBookScreenState();
  }
}

class _CashBookScreenState extends State<CashBookScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  CashBookModelListDetails models = CashBookModelListDetails([]);
  bool _isLoading = true;
  bool _filterExpanded = false;

  final List<bool> _typeOptionSelections = [true, false, false];
  int previousTypeSelectedOptionIndex = 0;
  SortFilter sortType = SortFilter.LATEST;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    return RefreshIndicator(
        onRefresh: () async {
          databaseRepository.retrieveCashBooks();
        },
        child: Scaffold(
            backgroundColor: const Color(0x00ffffff),
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _filterExpanded = true;
                      });
                      Utility.createModalSheet(context, const FilterScreen(),
                          enableDrag: false, onComplete: () {
                        setState(() {
                          _filterExpanded = false;
                            });
                          });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Filters (${models.models.length})',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 2),
                          child: Icon(
                            _filterExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ],
                    )),
              ],
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0,
              title: const Text(
                'DEBTS',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCard(SizedBox(
                        height: 200, child: chartX(modelListDetails: models))),
                    buildCard(buildInOutCashDetails()),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOperationNumberWidget(),
                          buildSortPopUpMenu(),
                        ],
                      ),
                    ),
                    buildTypeFilter(),
                    SizedBox(
                        height: 200, child: buildOperationListWidget(context)),
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
                    )
                  ],
                ),
              ),
            )));
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
              //showLoadingBar();
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
              //  showLoadingBar();
              await databaseRepository.setTypeInPreferences(TypeFilter.CASH_IN);
              databaseRepository.retrieveFilteredCashBooks();
            },
          ),
        ),
        buildChoiceChip(
          _typeOptionSelections[2],
          'Outcome',
          (value) async {
            // showLoadingBar();
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

  Widget buildSortPopUpMenu() {
    return PopupMenuButton<SortFilter>(
      initialValue: sortType,
      elevation: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      iconSize: 20,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      onSelected: (sortType) async {
        // showLoadingBar();
        await databaseRepository.setSortInPreferences(sortType);
        databaseRepository.retrieveFilteredCashBooks(
            /*sortFilter: SortFilter.CASH_LOW_TO_HIGH*/);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortFilter>>[
        const PopupMenuItem(
          value: SortFilter.CASH_LOW_TO_HIGH,
          child: Text('Cash:Low to high'),
        ),
        const PopupMenuItem(
          value: SortFilter.CASH_HIGH_TO_LOW,
          child: Text('Cash:High to low'),
        ),
        const PopupMenuItem(
          value: SortFilter.LATEST,
          child: Text('Latest'),
        ),
        const PopupMenuItem(
          value: SortFilter.OLDER,
          child: Text('Oldest'),
        ),
      ],
    );
  }

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
    final prefs = await SharedPreferences.getInstance();
    updateTypeFilter(FilterSharedPreferences.getTypesFromPreferences(prefs));
    sortType = FilterSharedPreferences.getSortFromPreferences(prefs) ??
        SortFilter.LATEST;
    print('sortType $sortType');
    Future.delayed(const Duration(milliseconds: 200), () {
      //to dismiss the loading bar
      setState(() {
        //to dismiss loading bar
        //  Navigator.of(context).pop();
        models = insertedModels;
      });
    });
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    updateTypeFilter(FilterSharedPreferences.getTypesFromPreferences(prefs));
    sortType = FilterSharedPreferences.getSortFromPreferences(prefs) ??
        SortFilter.LATEST;
    setState(() {
      _isLoading = false;
      //initial setup for models
      this.models = models;
    });
  }

  Widget buildCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 0,
        color: const Color(0xffEFF8FD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
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

  void updateTypeFilter(TypeFilter? type) {
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

  void showLoadingBar() {
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
