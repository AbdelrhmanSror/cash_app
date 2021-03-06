import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';
import 'package:debts_app/cashbook/utility/FilterSharedPreferences.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/utility/dataClasses/Date.dart';
import 'package:debts_app/cashbook/widgets/functional/ExpandableWidget.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../main.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<FilterScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  bool isLoading = true;

  //variable indicate if we reset the filter system or not
  bool isCleared = false;

  String _fromDate = '';
  String _toDate = '';

  //the variable that controls the height of the current widget on the screen.
  final double _screenPercentage = 0.4;

  //variable represents the state of date filter options list arrow
  bool _dateExpanded = true;
  bool _sortExpanded = true;
  bool _typeExpanded = true;


  //number of retrieved models;
  int _count = 0;

  final _dateOptionSelections = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  int previousDateSelectedOptionIndex = 0;

  final _sortOptionSelections = [false, false, false, false];
  int previousSortSelectedOptionIndex = 0;

  @override
  void initState() {
    super.initState();
    databaseRepository.registerCashBookDatabaseListener(this);
    databaseRepository.retrieveCashBooksForFirstTime();
    //   print('models are ${ databaseRepository.getAllCashBooks()}\n');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    } else {
      return Container(
        color: const Color(0xffEFF8FD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Material(
              color: const Color(0xFF3345A6),
              elevation: 0.5,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 8, top: 8, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FILTER',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white)))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
              child: Container(
                  alignment: Alignment.bottomCenter,
                  constraints: BoxConstraints.loose(Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * _screenPercentage)),
                  child: buildFilterWidget()),
            ),
            Material(
              elevation: 2,
              color: const Color(0xffEFF8FD),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 4, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedTextButton(
                        hide: isCleared,
                        text: const Text(
                          'Clear Filters',
                          style: TextStyle(color: Color(0xFF3345A6)),
                        ),
                        radius: 5,
                        backgroundColor: const Color(0xffEFF8FD),
                        paddingLeft: 8,
                        paddingTop: 7,
                        paddingRight: 8,
                        paddingBottom: 8,
                        elevation: 1,
                        onPressed: () async {
                          //clear all data in preferences
                          showLoadingBar();
                          await databaseRepository.clearFilter();
                        }),
                    RoundedTextButton(
                        text: Text(
                          'Show $_count Results',
                          style: const TextStyle(color: Colors.white),
                        ),
                        radius: 5,
                        backgroundColor: const Color(0xFF3345A6),
                        paddingLeft: 8,
                        paddingTop: 8,
                        paddingRight: 8,
                        paddingBottom: 8,
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget buildFilterWidget() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDateTitle(),
            buildDateSelection(),
            buildDivider(),
          /*  buildCashTitle(),
            buildCashSlider(),
            buildDivider(),*/
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildSortTitle(),
            ),
            buildSortingSelection()
          ],
        )
      ],
    );
  }

  Row buildDateTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Date',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                FilterSharedPreferences.flipArrowState(
                    FilterArrowState.dateArrow);
                _dateExpanded = !_dateExpanded;
              });
            },
            icon: Icon(_dateExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded))
      ],
    );
  }

  Row buildTypeTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Type',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                FilterSharedPreferences.flipArrowState(
                    FilterArrowState.typeArrow);
                _typeExpanded = !_typeExpanded;
              });
            },
            icon: Icon(_typeExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded))
      ],
    );
  }



  Row buildSortTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        IconButton(
            onPressed: () async {
              FilterSharedPreferences.flipArrowState(
                  FilterArrowState.sortArrow);
              setState(() {
                _sortExpanded = !_sortExpanded;
              });
            },
            icon: Icon(_sortExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded))
      ],
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget buildDateSelection() {
    return ExpandableWidget(
      expand: _dateExpanded,
      child: Column(
        children: [
          buildDateFilterSystem(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.date_range_rounded,
                color: Color(0xFF3345A6),
                size: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: AppTextWithDot(
                      text: 'From date',
                      style: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  AppTextWithDot(
                    text: _fromDate,
                    style: const TextStyle(
                        color: Color(0xFF3345A6),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
                child: VerticalDivider(
                  color: Colors.blueGrey.shade200,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),
              ),
              const Icon(
                Icons.date_range_rounded,
                color: Color(0xFF3345A6),
                size: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: AppTextWithDot(
                      text: 'To Date',
                      style: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  AppTextWithDot(
                    text: _toDate,
                    style: const TextStyle(
                        color: Color(0xFF3345A6),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSortingSelection() {
    return ExpandableWidget(
      expand: _sortExpanded,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        children: [
          buildChoiceChip(
            _sortOptionSelections[0],
            'Cash:Low to high',
            () async {
              showLoadingBar();
              await databaseRepository
                  .setSortInPreferences(SortFilter.cashLowToHigh);
              databaseRepository.retrieveFilteredCashBooks(
                  /*sortFilter: SortFilter.CASH_LOW_TO_HIGH*/);
            },
          ),
          buildChoiceChip(
            _sortOptionSelections[1],
            'Cash:High to low',
            () async {
              showLoadingBar();
              await databaseRepository
                  .setSortInPreferences(SortFilter.cashHighToLow);

              databaseRepository.retrieveFilteredCashBooks(
                  /* sortFilter: SortFilter.CASH_HIGH_TO_LOW*/);
            },
          ),
          buildChoiceChip(
            _sortOptionSelections[2],
            'Latest',
            () async {
              showLoadingBar();
              await databaseRepository.setSortInPreferences(SortFilter.latest);

              databaseRepository.retrieveFilteredCashBooks(
                  /* sortFilter: SortFilter.LATEST*/);
            },
          ),
          buildChoiceChip(
            _sortOptionSelections[3],
            'Older',
            () async {
              showLoadingBar();
              await databaseRepository.setSortInPreferences(SortFilter.older);
              databaseRepository.retrieveFilteredCashBooks(
                  /* sortFilter: SortFilter.OLDER*/);
            },
          )
        ],
      ),
    );
  }

  Widget buildDateFilterSystem() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 0,
      children: [
        buildChoiceChip(
            _dateOptionSelections[0], 'This Week', () => onThisWeekSelected()),
        buildChoiceChip(_dateOptionSelections[1], 'Last 7 Days',
            () => onLast7DaysSelected()),
        buildChoiceChip(_dateOptionSelections[2], 'Last 30 Days',
            () => onLast30DaysSelected()),
        buildChoiceChip(_dateOptionSelections[3], 'Last Month',
            () => onLastMonthSelected()),
        buildChoiceChip(
            _dateOptionSelections[4], 'This Year', () => onThisYearSelected()),
        buildChoiceChip(
            _dateOptionSelections[5], 'ALL', () => onAllDateSelected()),
        buildChoiceChip(
            _dateOptionSelections[6], 'Custom', () => onCustomSelected()),
      ],
    );
  }

  void onAllDateSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(null);
    databaseRepository.setDateTypeInPreferences(DateFilter.all);
    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onCustomSelected() {
    Utility.createModalSheet(
        context,
        Container(
          height: 350,
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildDatePicker((startDate, endDate) async {
              showLoadingBar();
              await databaseRepository
                  .setDateTypeInPreferences(DateFilter.custom);
              databaseRepository.setDateRangeInPreferences(
                  Date(startDate.toString(), endDate.toString()));
              databaseRepository.retrieveFilteredCashBooks();
            }),
          ),
        ),
        enableDrag: true);
  }

  void onLastMonthSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInLastMonth());
    databaseRepository.setDateTypeInPreferences(DateFilter.lastMonth);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onLast30DaysSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInLast30Days());
    databaseRepository.setDateTypeInPreferences(DateFilter.last30Days);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onThisYearSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInCurrentYear());
    databaseRepository.setDateTypeInPreferences(DateFilter.thisYear);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onLast7DaysSelected() async {
    showLoadingBar();

    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInLast7Days());
    databaseRepository.setDateTypeInPreferences(DateFilter.last7Days);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onThisWeekSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInCurrentWeek());
    databaseRepository.setDateTypeInPreferences(DateFilter.thisWeek);
    //fetch date by data in this week
    databaseRepository.retrieveFilteredCashBooks(
        /*date: date, sortFilter: SortFilter.LATEST*/);
  }

  void dismissLoadingBar() {
    isLoading = false;
    Navigator.of(context).pop();
  }

  void showLoadingBar() {
    isLoading = true;
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

  /* Widget buildDateFilterChip(bool selected, String text, Function onSelected) {
    return RawMaterialButton(
      elevation: 0,
      onPressed: () => onSelected(),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      child: Text(
        text,
        style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w700),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: selected ? const Color(0xFF3345A6) : Colors.grey.shade300,
            width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      fillColor: selected ? const Color(0xFF3345A6) : const Color(0xffEFF8FD),
    );
  }
*/
  Widget buildDatePicker(Function(DateTime, DateTime) onDateSelected) {
    final datePicker = SfDateRangePicker(
      showNavigationArrow: true,
      showActionButtons: true,
      selectionMode: DateRangePickerSelectionMode.range,
      view: DateRangePickerView.month,
      onCancel: () {
        Navigator.of(context).pop();
      },
      onSubmit: (selection) {
        //in case user did not enter the date complete.
        if (selection == null) {
          Navigator.of(context).pop();
          return;
        }
        final value = selection as PickerDateRange;
        if (value.startDate == null || value.endDate == null) {
          Navigator.of(context).pop();
          return;
        }
        //submit
        Navigator.of(context).pop();
        onDateSelected(value.startDate!, value.endDate!);
      },
    );
    return datePicker;
  }

  Widget buildChoiceChip(bool selected, String text, Function onSelected) {
    return FilterChip(
      selected: selected,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: selected ? const Color(0xFF3345A6) : Colors.grey.shade300,
            width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      backgroundColor:
          selected ? const Color(0xFF3345A6) : const Color(0xffEFF8FD),
      checkmarkColor: Colors.white,
      label: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w800),
        ),
      ),
      selectedColor: const Color(0xFF3345A6),
      onSelected: (bool value) {
        onSelected();
      },
    );
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;
    final cashType = await databaseRepository.getTypesFromPreferences();
    await updateFilterUi(models.applyType(cashType));
    await initArrowState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void onDatabaseChanged(CashBookModelListDetails models) async {
    if (!mounted) return;
    final cashType = await databaseRepository.getTypesFromPreferences();
    await updateFilterUi(models.applyType(cashType));
    //to dismiss the loading bar
    setState(() {
      dismissLoadingBar();
    });
  }

  Future<void> updateFilterUi(CashBookModelListDetails models) async {
    final dateType = await databaseRepository.getDateTypeFromPreferences();
    final date = await databaseRepository.getDateFromPreferences();
    final sortFilter = await databaseRepository.getSortFromPreferences();
    //if all is null then all is either cleared or not yet filtered
    if (await databaseRepository.isFilterCleared()) {
      isCleared = true;
      await initArrowState();
    } else {
      isCleared = false;
    }
    updateCount(models);
    updateDateFilter(date, dateType);
    updateSortFilter(sortFilter);
  }

  void updateCount(CashBookModelListDetails models) {
    _count = models.models.length;
  }

  Future<void> initArrowState() async {
    _dateExpanded =
        await databaseRepository.getArrowState(FilterArrowState.dateArrow);
    _typeExpanded =
        await databaseRepository.getArrowState(FilterArrowState.typeArrow);
    _sortExpanded =
        await databaseRepository.getArrowState(FilterArrowState.sortArrow);
  }


  void updateSortFilter(SortFilter sortFilter) {
    _sortOptionSelections[previousSortSelectedOptionIndex] = false;
    if (sortFilter == SortFilter.cashLowToHigh) {
      _sortOptionSelections[0] = true;
      previousSortSelectedOptionIndex = 0;
    }
    if (sortFilter == SortFilter.cashHighToLow) {
      _sortOptionSelections[1] = true;
      previousSortSelectedOptionIndex = 1;
    }
    if (sortFilter == SortFilter.latest) {
      _sortOptionSelections[2] = true;
      previousSortSelectedOptionIndex = 2;
    }
    if (sortFilter == SortFilter.older) {
      _sortOptionSelections[3] = true;
      previousSortSelectedOptionIndex = 3;
    }
  }

  void updateDateFilter(Date date, DateFilter? dateType) {
    _fromDate =
        DateUtility.getDateRepresentation(DateTime.parse(date.firstDate));
    _toDate = DateUtility.getDateRepresentation(DateTime.parse(date.lastDate));
    _dateOptionSelections[previousDateSelectedOptionIndex] = false;
    // if (dateType != null) this.dateType = dateType;
    if (dateType == DateFilter.thisWeek) {
      _dateOptionSelections[0] = true;
      previousDateSelectedOptionIndex = 0;
    } else if (dateType == DateFilter.last7Days) {
      _dateOptionSelections[1] = true;
      previousDateSelectedOptionIndex = 1;
    } else if (dateType == DateFilter.last30Days) {
      _dateOptionSelections[2] = true;
      previousDateSelectedOptionIndex = 2;
    } else if (dateType == DateFilter.lastMonth) {
      _dateOptionSelections[3] = true;
      previousDateSelectedOptionIndex = 3;
    } else if (dateType == DateFilter.thisYear) {
      _dateOptionSelections[4] = true;
      previousDateSelectedOptionIndex = 4;
    } else if (dateType == DateFilter.custom) {
      _dateOptionSelections[6] = true;
      previousDateSelectedOptionIndex = 6;
    } else if (dateType == DateFilter.all) {
      _dateOptionSelections[5] = true;
      previousDateSelectedOptionIndex = 5;
    }
  }
}
