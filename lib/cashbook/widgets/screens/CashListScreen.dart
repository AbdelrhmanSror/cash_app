import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/NetBalanceWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationNumberWidget.dart';
import 'package:debts_app/cashbook/widgets/screens/CashBookScreen.dart';
import 'package:debts_app/cashbook/widgets/screens/ScreenNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../main.dart';

class CashListScreen extends StatefulWidget {
  CashListScreen({Key? key}) : super(key: key);
  CashBookModelListDetails modelListDetails = CashBookModelListDetails([]);

  @override
  State<CashListScreen> createState() {
    return _CashListScreenState();
  }
}

class _CashListScreenState extends State<CashListScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  bool _isLoading = true;

  final List<bool> _typeOptionSelections = [true, false, false];
  int previousTypeSelectedOptionIndex = 0;
  SortFilter sortType = SortFilter.latest;

  DateFilter dateType = DateFilter.all;
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
              databaseRepository.retrieveFilteredCashBooks();
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
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
                floatingActionButton: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  icon: Icons.add,
                  backgroundColor: const Color(0xFF3345A6),
                  activeBackgroundColor: Colors.red,
                  activeIcon: Icons.close,
                  spacing: 3,
                  childPadding: const EdgeInsets.all(4),
                  spaceBetweenChildren: 5,
                  buttonSize: const Size(50.0, 50),
                  childrenButtonSize: const Size(50.0, 50.0),
                  visible: true,
                  direction: SpeedDialDirection.up,
                  switchLabelPosition: false,

                  /// If true user is forced to close dial manually
                  closeManually: false,

                  /// If false, backgroundOverlay will not be rendered.
                  renderOverlay: true,
                  useRotationAnimation: true,
                  tooltip: 'Open Speed Dial',
                  heroTag: 'hero-tag',
                  elevation: 8.0,
                  animationSpeed: 200,
                  shape: const StadiumBorder(),
                  children: [
                    SpeedDialChild(
                        child: const Icon(Icons.attach_money),
                        backgroundColor: const Color(0xF5C0F8B2),
                        foregroundColor: Colors.green,
                        label: 'Cash In',
                        onTap: () => ScreenNavigation.navigateToCashInScreen(
                            context, OperationType.insert)),
                    SpeedDialChild(
                        child: const Icon(Icons.money_off),
                        backgroundColor: const Color(0xCCFDF1F3),
                        foregroundColor: Colors.red,
                        label: 'Cash out',
                        onTap: () => ScreenNavigation.navigateToCashOutScreen(
                            context, OperationType.insert)),
                    SpeedDialChild(
                      visible: widget.modelListDetails.models.isNotEmpty,
                      child: const Icon(Icons.archive_outlined),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      label: 'Archive',
                      onTap: () =>
                          ScreenNavigation.navigateToArchiveModalSheetScreen(
                              context, widget.modelListDetails),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomAppBar(
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 8.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: "Search",
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.archive_outlined),
                        tooltip: " Operations Archive",
                        onPressed: () {
                          ScreenNavigation.navigateToParentArchiveScreen(
                              context);
                        },
                      )
                    ],
                  ),
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Column(
                    children: [
                      buildTypeFilter(),
                      Expanded(child: buildOperationListWidget(context)),
                      //buildCashInOutButton(context)
                    ],
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
              // showLoadingBar();
              await databaseRepository.setTypeInPreferences(TypeFilter.all);
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
              // showLoadingBar();
              await databaseRepository.setTypeInPreferences(TypeFilter.cashIn);
              databaseRepository.retrieveFilteredCashBooks();
            },
          ),
        ),
        buildChoiceChip(
          _typeOptionSelections[2],
          'Outcome',
          (value) async {
            //  showLoadingBar();
            await databaseRepository.setTypeInPreferences(TypeFilter.cashOut);
            databaseRepository.retrieveFilteredCashBooks();
          },
        ),
      ],
    );
  }

  OperationListWidget buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        slideable: true,
        itemComparator: (e1, e2) =>
            widget.modelListDetails.itemSortComparator(sortType, e1, e2),
        groupBy: (element) => element.groupId,
        onDeletePressed: (element) {
          databaseRepository.deleteCashBook(element);
        },
        onEditPressed: (element) {
          ScreenNavigation.navigateToEditScreen(context, element);
        },
        onArchivePressed: (element) {
          databaseRepository.archiveCashBooks([element]);
        },
        models: widget.modelListDetails.models,
        onItemPressed: (model) {
          ScreenNavigation.navigateToListDetailScreen(context, model);
        });
  }

  OperationNumberWidget buildOperationNumberWidget() {
    return OperationNumberWidget(
        countNumber: widget.modelListDetails.models.length);
  }

  NetBalanceWidget buildNetBalanceWidget() {
    return NetBalanceWidget(
      netBalance: widget.modelListDetails.models.isEmpty
          ? 0
          : widget.modelListDetails.getBalance(),
    );
  }

  Widget buildInOutCashDetails() =>
      InOutCashDetails(models: widget.modelListDetails);

  @override
  void initState() {
    super.initState();
    //databaseRepository.insertCashBook(CashBookModel(date: (DateTime.now()).add(const Duration(days: 1)).toString(), cash: -2000, type: TypeFilter.cashOut.value));

    //register this widget as listener to the any updates happen in the database
    databaseRepository.registerCashBookDatabaseListener(this);
    //retrieve all the data in the database to initialize our app
    databaseRepository.retrieveCashBooksForFirstTime();
  }

  @override
  void onDatabaseChanged(CashBookModelListDetails insertedModels) async {
    if (!mounted) return;
    sortType = await databaseRepository.getSortFromPreferences();
    final cashType = await databaseRepository.getTypesFromPreferences();
    updateTypeFilter(cashType);
    setState(() {
      //to dismiss loading bar
      dismissLoadingBar();
      widget.modelListDetails =
          insertedModels.applyType(cashType).applySort(sortType);
      //when grouping item in list
    });
    // });
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;
    sortType = await databaseRepository.getSortFromPreferences();
    final cashType = await databaseRepository.getTypesFromPreferences();
    updateTypeFilter(cashType);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        //to dismiss loading bar
        _isLoading = false;
        widget.modelListDetails =
            models.applyType(cashType).applySort(sortType);
        //when grouping item in list
      });
    });

    // });
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
    if (type == TypeFilter.cashIn) {
      _typeOptionSelections[1] = true;
      previousTypeSelectedOptionIndex = 1;
      return;
    }
    if (type == TypeFilter.cashOut) {
      _typeOptionSelections[2] = true;
      previousTypeSelectedOptionIndex = 2;
      return;
    }
    _typeOptionSelections[0] = true;
    previousTypeSelectedOptionIndex = 0;
  }

  void dismissLoadingBar() {
    if (_isLoading) {
      _isLoading = false;
      Navigator.of(context).pop();
    }
  }

  void showLoadingBar() {
    _isLoading = true;
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        );
      },
      context: context,
    );
  }
}
