import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationListWidget.dart';
import 'package:debts_app/cashbook/widgets/functional/SearchBarWidget.dart';
import 'package:debts_app/cashbook/widgets/screens/CashBookScreen.dart';
import 'package:debts_app/cashbook/widgets/screens/ScreenNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../main.dart';

class CashListScreen extends StatefulWidget {
  const CashListScreen({Key? key}) : super(key: key);

  @override
  State<CashListScreen> createState() {
    return _CashListScreenState();
  }
}

class _CashListScreenState extends State<CashListScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  CashBookModelListDetails _modelListDetails = CashBookModelListDetails([]);
  bool _isLoading = true;

  final List<bool> _typeOptionSelections = [true, false, false];
  int _previousTypeSelectedOptionIndex = 0;
  SortFilter _sortType = SortFilter.latest;
  TextEditingController textController = TextEditingController();
  double? filterCash;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            color: const Color(0xFF3345A6),
            displacement: 100,
            onRefresh: _handleRefresh,
            child: Scaffold(
              body: Scaffold(
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
                        visible: _modelListDetails.models.isNotEmpty,
                        child: const Icon(Icons.archive_outlined),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        label: 'Archive',
                        onTap: () =>
                            ScreenNavigation.navigateToArchiveModalSheetScreen(
                                context, _modelListDetails),
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
                        buildSearchBar(context),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTypeFilter(),
                          ],
                        ),
                        Expanded(child: _buildOperationListWidget(context)),
                        //buildCashInOutButton(context)
                      ],
                    ),
                  )),
            ));
  }

  SearchBar buildSearchBar(BuildContext context) {
    return SearchBar(
      closeSearchOnSuffixTap: false,
      autoFocus: true,
      width: MediaQuery.of(context).size.width - 110,
      textInputType: TextInputType.number,
      textController: textController,
      onSuffixTap: () {
        setState(() {
          textController.clear();
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    //delaying the refresh indicator for 1 sec.
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    databaseRepository.retrieveFilteredCashBooks();
  }

  Widget _buildTypeFilter() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: _buildChoiceChip(
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
          child: _buildChoiceChip(
            _typeOptionSelections[1],
            'Income',
            (value) async {
              // showLoadingBar();
              await databaseRepository.setTypeInPreferences(TypeFilter.cashIn);
              databaseRepository.retrieveFilteredCashBooks();
            },
          ),
        ),
        _buildChoiceChip(
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

  OperationListWidget _buildOperationListWidget(BuildContext context) {
    return OperationListWidget(
        slideable: true,
        itemComparator: (e1, e2) =>
            _modelListDetails.itemSortComparator(_sortType, e1, e2),
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
        models: _modelListDetails.models,
        onItemPressed: (model) {
          ScreenNavigation.navigateToListDetailScreen(context, model);
        });
  }

  @override
  void initState() {
    super.initState();
    //databaseRepository.insertCashBook(CashBookModel(date: (DateTime.now()).add(const Duration(days: 1)).toString(), cash: -2000, type: TypeFilter.cashOut.value));

    //register this widget as listener to the any updates happen in the database
    databaseRepository.registerCashBookDatabaseListener(this);
    //retrieve all the data in the database to initialize our app
    databaseRepository.retrieveCashBooksForFirstTime();
    textController.addListener(() {
      filterCash = double.tryParse(textController.text);
      databaseRepository.retrieveFilteredCashBooks();
    });
  }

  @override
  void onDatabaseChanged(CashBookModelListDetails insertedModels) async {
    if (!mounted) return;
    _sortType = await databaseRepository.getSortFromPreferences();
    final cashType = await databaseRepository.getTypesFromPreferences();
    _updateTypeFilter(cashType);
    setState(() {
      //to dismiss loading bar
      _isLoading = false;
      _modelListDetails = insertedModels
          .applyType(cashType)
          .applySort(_sortType)
          .applyCash(filterCash);
      //when grouping item in list
    });
    // });
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;
    _sortType = await databaseRepository.getSortFromPreferences();
    final cashType = await databaseRepository.getTypesFromPreferences();
    _updateTypeFilter(cashType);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        //to dismiss loading bar
        _isLoading = false;
        _modelListDetails = models.applyType(cashType).applySort(_sortType);
        //when grouping item in list
      });
    });

    // });
  }

  Widget _buildChoiceChip(
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

  void _updateTypeFilter(TypeFilter type) {
    _typeOptionSelections[_previousTypeSelectedOptionIndex] = false;
    if (type == TypeFilter.cashIn) {
      _typeOptionSelections[1] = true;
      _previousTypeSelectedOptionIndex = 1;
      return;
    }
    if (type == TypeFilter.cashOut) {
      _typeOptionSelections[2] = true;
      _previousTypeSelectedOptionIndex = 2;
      return;
    }
    _typeOptionSelections[0] = true;
    _previousTypeSelectedOptionIndex = 0;
  }
}
