import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/DateUtility.dart';
import 'package:debts_app/utility/FilterSharedPreferences.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/utility/dataClasses/Cash.dart';
import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/utility/dataClasses/Date.dart';
import 'package:debts_app/widgets/functional/ExpandableWidget.dart';
import 'package:debts_app/widgets/functional/RectangleTitleArea.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../main.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<FilterScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  bool isLoadingFirst = true;

  //variable indicate if we reset the filter system or not
  bool isCleared = true;

  String _fromDate = '';
  String _toDate = '';

  //the variable that controls the height of the current widget on the screen.
  final double _screenPercentage = 0.4;

  //variable represents the state of date filter options list arrow
  bool _dateExpanded = true;
  bool _cashExpanded = true;
  bool _sortExpanded = true;
  bool _typeExpanded = true;

  double _maxCash = 0;
  double _minCash = 0;
  double _startPrice = 0;
  double _endPrice = 0;

  //number of retrieved models;
  int _count = 0;

  final _dateOptionSelections = [false, false, false, false, false, false];
  int previousDateSelectedOptionIndex = 0;

  final List<bool> _typeOptionSelections = [false, false];
  int previousTypeSelectedOptionIndex = 0;

  final _sortOptionSelections = [false, false, false, false];
  int previousSortSelectedOptionIndex = 0;

  @override
  void initState() {
    super.initState();
    databaseRepository.registerCashBookDatabaseListener(this);
    databaseRepository.retrieveCashBooks();
    //   print('models are ${ databaseRepository.getAllCashBooks()}\n');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingFirst) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            color: Colors.blue,
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
                        style: TextStyle(color: Colors.blue),
                      ),
                      radius: 5,
                      backgroundColor: Theme.of(context).canvasColor,
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
                      backgroundColor: Colors.blue,
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
            buildTypeTitle(),
            buildTypeSelection(),
            buildDivider(),
            buildCashTitle(),
            buildCashSlider(),
            buildDivider(),
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
                _typeExpanded = !_typeExpanded;
              });
            },
            icon: Icon(_typeExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded))
      ],
    );
  }

  Row buildCashTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Cash',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _cashExpanded = !_cashExpanded;
              });
            },
            icon: Icon(_cashExpanded
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
            onPressed: () {
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
                color: Colors.blue,
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
                      color: Colors.blueGrey.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  AppTextWithDot(
                    text: _fromDate,
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
                color: Colors.blue,
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
                      color: Colors.blueGrey.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  AppTextWithDot(
                    text: _toDate,
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTypeSelection() {
    return ExpandableWidget(
      expand: _typeExpanded,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilterChip(
              label: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Cash In',
                  style: TextStyle(
                      color:
                          _typeOptionSelections[0] ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              selected: _typeOptionSelections[0],
              checkmarkColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: _typeOptionSelections[0]
                        ? Colors.blue.shade200
                        : Colors.grey.shade50,
                    width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              onSelected: (value) async {
                showLoadingBar();
                databaseRepository.setTypeInPreferences(TypeFilter.CASH_IN);
                databaseRepository.retrieveFilteredCashBooks();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilterChip(
              label: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Cash Out',
                    style: TextStyle(
                        color: _typeOptionSelections[1]
                            ? Colors.blue
                            : Colors.black,
                        fontWeight: FontWeight.normal)),
              ),
              selected: _typeOptionSelections[1],
              selectedColor: Colors.blue.shade50,
              checkmarkColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: _typeOptionSelections[1]
                        ? Colors.blue.shade200
                        : Colors.grey.shade50,
                    width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              onSelected: (value) async {
                showLoadingBar();
                databaseRepository.setTypeInPreferences(TypeFilter.CASH_OUT);
                databaseRepository.retrieveFilteredCashBooks();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildCashSlider() {
    return ExpandableWidget(
      expand: _cashExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RectangleTitleArea(
            title1: const AppTextWithDot(
              text: 'Start Cash',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            subTitle1: TextButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) {
                      final focusNode = FocusNode();
                      final dialog = AlertDialog(
                        content: TextField(
                          focusNode: focusNode,
                          onSubmitted: (number) async {
                            Navigator.of(context).pop();
                            final value = double.parse(number);
                            if (cashInRange(number) && value <= _endPrice) {
                              showLoadingBar();
                              // _startPrice = value;
                              await databaseRepository
                                  .setCashRangeInPreferences(
                                      CashRange(value, _endPrice));

                              databaseRepository.retrieveFilteredCashBooks();
                            }
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration.collapsed(
                              hintText: 'Start Cash',
                              fillColor: Colors.grey.shade50),
                        ),
                      );
                      Utility.showKeyboard(focusNode, duration: 100);
                      return dialog;
                    },
                  );
                },
                child: Text('${_startPrice.toInt()} EGP',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal))),
            title2: const AppTextWithDot(
              text: 'End Cash',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            subTitle2: TextButton(
                onPressed: () {
                  final focusNode = FocusNode();
                  showDialog<bool>(
                    context: context,
                    builder: (context) {
                      final dialog = AlertDialog(
                        content: TextField(
                          focusNode: focusNode,
                          onSubmitted: (number) async {
                            Navigator.of(context).pop();

                            final value = double.parse(number);
                            //only if the number is bigger than the least number
                            if (cashInRange(number) && value >= _startPrice) {
                              showLoadingBar();
                              // _endPrice = value;
                              await databaseRepository
                                  .setCashRangeInPreferences(
                                      CashRange(_startPrice, value));
                              databaseRepository.retrieveFilteredCashBooks();
                            }
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration.collapsed(
                              hintText: 'End Cash',
                              fillColor: Colors.grey.shade50),
                        ),
                      );
                      Utility.showKeyboard(focusNode, duration: 100);
                      return dialog;
                    },
                  );
                },
                child: Text(
                  '${_endPrice.toInt()} EGP',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.normal),
                )),
          ),
        ],
      ),
    );
  }

  Widget buildSortingSelection() {
    return ExpandableWidget(
      expand: _sortExpanded,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: buildChoiceChip(
                  _sortOptionSelections[0],
                  'Cash:Low to high',
                  () async {
                    showLoadingBar();
                    await databaseRepository
                        .setSortInPreferences(SortFilter.CASH_LOW_TO_HIGH);
                    databaseRepository.retrieveFilteredCashBooks(
                        /*sortFilter: SortFilter.CASH_LOW_TO_HIGH*/);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: buildChoiceChip(
                  _sortOptionSelections[1],
                  'Cash:High to low',
                      () async {
                    showLoadingBar();
                    await databaseRepository
                        .setSortInPreferences(SortFilter.CASH_HIGH_TO_LOW);

                    databaseRepository.retrieveFilteredCashBooks(
                        /* sortFilter: SortFilter.CASH_HIGH_TO_LOW*/);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: buildChoiceChip(
                  _sortOptionSelections[2],
                  'Latest',
                      () async {
                    showLoadingBar();
                    await databaseRepository
                        .setSortInPreferences(SortFilter.LATEST);

                    databaseRepository.retrieveFilteredCashBooks(
                        /* sortFilter: SortFilter.LATEST*/);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: buildChoiceChip(
                  _sortOptionSelections[3],
                  'Older',
                      () async {
                    showLoadingBar();
                    await databaseRepository
                        .setSortInPreferences(SortFilter.OLDER);
                    databaseRepository.retrieveFilteredCashBooks(
                        /* sortFilter: SortFilter.OLDER*/);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool cashInRange(String number) {
    return double.parse(number) <= _maxCash && double.parse(number) >= _minCash;
  }

  Widget buildDateFilterSystem() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildChoiceChip(_dateOptionSelections[0], 'This Week', () {
            onThisWeekSelected();
          }),
          buildChoiceChip(_dateOptionSelections[1], 'Last 7 Days', () {
            onLast7DaysSelected();
          }),
          buildChoiceChip(_dateOptionSelections[2], 'This Year', () {
            onThisYearSelected();
          })
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildChoiceChip(_dateOptionSelections[3], 'Last 30 Days', () {
            onLast30DaysSelected();
          }),
          buildChoiceChip(_dateOptionSelections[4], 'Last Month', () {
            onLastMonthSelected();
          }),
          buildChoiceChip(_dateOptionSelections[5], 'Custom', () {
            onCustomSelected();
          })
        ],
      ),
    ]);
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
                  .setDateTypeInPreferences(DateFilter.CUSTOM);
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
    databaseRepository.setDateTypeInPreferences(DateFilter.LAST_MONTH);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onLast30DaysSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInLast30Days());
    databaseRepository.setDateTypeInPreferences(DateFilter.LAST_30_DAYS);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onThisYearSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInCurrentYear());
    databaseRepository.setDateTypeInPreferences(DateFilter.THIS_YEAR);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onLast7DaysSelected() async {
    showLoadingBar();

    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInLast7Days());
    databaseRepository.setDateTypeInPreferences(DateFilter.LAST_7_DAYS);

    databaseRepository.retrieveFilteredCashBooks(/*date: date*/);
  }

  void onThisWeekSelected() async {
    showLoadingBar();
    await databaseRepository.setDateRangeInPreferences(
        DateUtility.getFirstAndLastDateInCurrentWeek());
    databaseRepository.setDateTypeInPreferences(DateFilter.THIS_WEEK);
    //fetch date by data in this week
    databaseRepository.retrieveFilteredCashBooks(
        /*date: date, sortFilter: SortFilter.LATEST*/);
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
            color: selected ? Colors.blue.shade200 : Colors.grey.shade50,
            width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.grey.shade200,
      checkmarkColor: Colors.blue,
      label: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: TextStyle(
              color: selected ? Colors.blue : Colors.black,
              fontWeight: FontWeight.normal),
        ),
      ),
      selectedColor: Colors.blue.shade50,
      onSelected: (bool value) {
        onSelected();
      },
    );
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;
    await updateFilterUi(models);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isLoadingFirst = false;
      });
    });
  }

  @override
  void onDatabaseChanged(CashBookModelListDetails models) async {
    if (!mounted) return;
    await updateFilterUi(models);
    Future.delayed(const Duration(milliseconds: 300), () {
      //to dismiss the loading bar
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  Future<void> updateFilterUi(CashBookModelListDetails models) async {
    //retrieve the max date and min date of the whole operation in the database
    // to initialize our date ui if there was no preferences
    final dateMinMax = await databaseRepository.getMinMaxDate();
    final cash = await databaseRepository.getMinMaxCash();
    _minCash = cash!.first;
    _maxCash = cash.last;
    FilterSharedPreferences.retrievedFilterPreferences(
        (date, type, cashRange, sortFilter, dateType) {
      //if all is null then all is either cleared or not yet filtered
      if (date == null &&
          type == null &&
          cashRange == null &&
          sortFilter == null &&
          dateType == null) {
        isCleared = true;
      } else {
        isCleared = false;
      }
      updateDateFilter(date, dateMinMax, dateType);

      updateTypeFilter(type);

      updateCashFilter(cashRange);

      updateSortFilter(sortFilter);

      _count = models.models.length;
    });
  }

  void updateCashFilter(CashRange? cashRange) {
    _startPrice = (cashRange == null) ? _minCash : cashRange.first;
    _endPrice = (cashRange == null) ? _maxCash : cashRange.last;
  }

  void updateSortFilter(SortFilter? sortFilter) {
    _sortOptionSelections[previousSortSelectedOptionIndex] = false;
    if (sortFilter == SortFilter.CASH_LOW_TO_HIGH) {
      _sortOptionSelections[0] = true;
      previousSortSelectedOptionIndex = 0;
    }
    if (sortFilter == SortFilter.CASH_HIGH_TO_LOW) {
      _sortOptionSelections[1] = true;
      previousSortSelectedOptionIndex = 1;
    }
    //by default make sorting by latest.
    if (sortFilter == SortFilter.LATEST || sortFilter == null) {
      _sortOptionSelections[2] = true;
      previousSortSelectedOptionIndex = 2;
    }
    if (sortFilter == SortFilter.OLDER) {
      _sortOptionSelections[3] = true;
      previousSortSelectedOptionIndex = 3;
    }
  }

  void updateTypeFilter(TypeFilter? type) {
    _typeOptionSelections[previousTypeSelectedOptionIndex] = false;
    if (type == TypeFilter.CASH_IN) {
      _typeOptionSelections[0] = true;
      previousTypeSelectedOptionIndex = 0;
    }
    if (type == TypeFilter.CASH_OUT) {
      _typeOptionSelections[1] = true;
      previousTypeSelectedOptionIndex = 1;
    }
  }

  void updateDateFilter(Date? date, Date? dateMinMax, DateFilter? dateType) {
    _fromDate = DateUtility.getAlphabeticDate(date == null
        ? DateTime.parse(dateMinMax!.firstDate)
        : DateTime.parse(date.firstDate));
    _toDate = DateUtility.getAlphabeticDate(date == null
        ? DateTime.parse(dateMinMax!.lastDate)
        : DateTime.parse(date.lastDate));

    _dateOptionSelections[previousDateSelectedOptionIndex] = false;
    if (dateType == DateFilter.THIS_WEEK) {
      _dateOptionSelections[0] = true;
      previousDateSelectedOptionIndex = 0;
    } else if (dateType == DateFilter.LAST_7_DAYS) {
      _dateOptionSelections[1] = true;
      previousDateSelectedOptionIndex = 1;
    } else if (dateType == DateFilter.THIS_YEAR) {
      _dateOptionSelections[2] = true;
      previousDateSelectedOptionIndex = 2;
    } else if (dateType == DateFilter.LAST_30_DAYS) {
      _dateOptionSelections[3] = true;
      previousDateSelectedOptionIndex = 3;
    } else if (dateType == DateFilter.LAST_MONTH) {
      _dateOptionSelections[4] = true;
      previousDateSelectedOptionIndex = 4;
    } else if (dateType == DateFilter.CUSTOM) {
      _dateOptionSelections[5] = true;
      previousDateSelectedOptionIndex = 5;
    }
  }
}
