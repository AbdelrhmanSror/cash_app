import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/DateUtility.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/utility/dataClasses/Date.dart';
import 'package:debts_app/widgets/functional/ExpandableWidget.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../main.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({required this.onDateSelected, Key? key}) : super(key: key);

  Function(DateTime, DateTime) onDateSelected;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<FilterScreen>
    implements CashBookDatabaseListener<CashBookModel> {
  String _fromDate = '';
  String _toDate = '';

  //the variable that controls the height of the current widget on the screen.
  final double _screenPercentage = 0.5;

  //variable represents the state of date filter options list arrow
  bool _expanded = false;

  double _maxCash = 1;
  double _minCash = 0;
  double _startPrice = 0;
  double _endPrice = 0;

  //number of retrieved models;
  int _count = 0;

  final _dateOptionSelections = [false, false, false, false, false, false];
  int previousDateSelectedOptionIndex = 0;

  @override
  void initState() {
    super.initState();
    databaseRepository.registerCashBookDatabaseListener(this);
    databaseRepository.retrieveCashBooks();
    //   print('models are ${ databaseRepository.getAllCashBooks()}\n');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          elevation: 0.5,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16.0, right: 8, top: 8, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FILTER',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue)))
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
                    onPressed: () {}),
                RoundedTextButton(
                    text: Text(
                      'Show $_count Results',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 5,
                    backgroundColor: Colors.blue,
                    paddingLeft: 8,
                    paddingTop: 8,
                    paddingRight: 8,
                    paddingBottom: 8,
                    onPressed: () {})
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildFilterWidget() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Show Operations for',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    icon: Icon(_expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded))
              ],
            ),
            buildDateSelection(_expanded),
            buildDivider(),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Type',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
            buildTypeSelection(),
            buildDivider(),
            const Text(
              'Price',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
            buildPriceSlider(),
            buildDivider(),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Sort By',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
            buildSortingSelection()
          ],
        )
      ],
    );
  }

  Divider buildDivider() {
    return const Divider(
      thickness: 0.2,
      color: Colors.grey,
    );
  }

  Widget buildSortingSelection() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: FilterChip(
                label: const Text('Cash: Low to High'),
                selected: true,
                onSelected: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: FilterChip(
                label: const Text('Cash: High to low'),
                selected: false,
                onSelected: (value) {},
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                label: Text('Latest'),
                selected: false,
                onSelected: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                label: Text('Older'),
                selected: false,
                onSelected: (value) {},
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FilterChip(
            label: Text('Cash In'),
            selected: true,
            onSelected: (value) {
              databaseRepository.fetchByType(CASH_IN);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FilterChip(
            label: Text('Cash Out'),
            selected: false,
            onSelected: (value) {
              databaseRepository.fetchByType(CASH_OUT);
            },
          ),
        )
      ],
    );
  }

  Widget buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(
              minWidth: double.infinity, maxWidth: double.infinity),
          child: SliderTheme(
            data: const SliderThemeData(
                trackHeight: 0.5, inactiveTrackColor: Colors.black),
            child: RangeSlider(
                values: RangeValues(_startPrice, _endPrice),
                min: _minCash,
                max: _maxCash,
                divisions: _maxCash.toInt(),
                onChanged: (value) {
                  setState(() {
                    _startPrice = value.start;
                    _endPrice = value.end;
                  });
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) {
                        final focusNode = FocusNode();
                        final dialog = AlertDialog(
                          content: TextField(
                            focusNode: focusNode,
                            onSubmitted: (number) {
                              setState(() {
                                if (cashInRange(number)) {
                                  _startPrice = double.parse(number);
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Start Price',
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
                          color: Colors.black, fontWeight: FontWeight.bold))),
              TextButton(
                  onPressed: () {
                    final focusNode = FocusNode();
                    showDialog<bool>(
                      context: context,
                      builder: (context) {
                        final dialog = AlertDialog(
                          content: TextField(
                            focusNode: focusNode,
                            onSubmitted: (number) {
                              setState(() {
                                //only if the number is bigger than the least number
                                if (cashInRange(number)) {
                                  _endPrice = double.parse(number);
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration.collapsed(
                                hintText: 'End Price',
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
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        )
      ],
    );
  }

  bool cashInRange(String number) {
    return double.parse(number) <= _maxCash && double.parse(number) >= _minCash;
  }

  Widget buildDateSelection(bool expand) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDateFilterSystem(expand),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CompositeWidget(
                width: 150,
                widgets: [
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
                vertical: true,
              ),
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CompositeWidget(
                width: 200,
                widgets: [
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
                vertical: true,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildDateFilterSystem(bool expand) {
    return ExpandableWidget(
      expand: expand,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDateChoiceChip(_dateOptionSelections[0], 'This Week', () {
              final date = DateUtility.getFirstAndLastDateInCurrentWeek();
              setState(() {
                //unselect the previously selected chip
                _dateOptionSelections[previousDateSelectedOptionIndex] = false;
                previousDateSelectedOptionIndex = 0;
                _dateOptionSelections[0] = true;
                _fromDate = date.firstDate;
                _toDate = date.lastDate;
              });
              //fetch date by data in this week
              databaseRepository.fetchByDateRange(date);
            }),
            buildDateChoiceChip(_dateOptionSelections[1], 'Last 7 Days', () {
              final date = DateUtility.getFirstAndLastDateInLast7Days();
              setState(() {
                //unselect the previously selected chip
                _dateOptionSelections[previousDateSelectedOptionIndex] = false;
                previousDateSelectedOptionIndex = 1;
                _dateOptionSelections[1] = true;
                _fromDate = date.firstDate;
                _toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(date);
            }),
            buildDateChoiceChip(_dateOptionSelections[2], 'This Year', () {
              final date = DateUtility.getFirstAndLastDateInCurrentYear();
              setState(() {
                //unselect the previously selected chip
                _dateOptionSelections[previousDateSelectedOptionIndex] = false;
                previousDateSelectedOptionIndex = 2;
                _dateOptionSelections[2] = true;
                _fromDate = date.firstDate;
                _toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(date);
            })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDateChoiceChip(_dateOptionSelections[3], 'Last 30 Days', () {
              final date = DateUtility.getFirstAndLastDateInLast30Days();
              setState(() {
                //unselect the previously selected chip
                _dateOptionSelections[previousDateSelectedOptionIndex] = false;
                previousDateSelectedOptionIndex = 3;
                _dateOptionSelections[3] = true;
                _fromDate = date.firstDate;
                _toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(date);
            }),
            buildDateChoiceChip(_dateOptionSelections[4], 'Last Month', () {
              final date = DateUtility.getFirstAndLastDateInLastMonth();
              setState(() {
                //unselect the previously selected chip
                _dateOptionSelections[previousDateSelectedOptionIndex] = false;
                previousDateSelectedOptionIndex = 4;
                _dateOptionSelections[4] = true;
                _fromDate = date.firstDate;
                _toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(date);
            }),
            buildDateChoiceChip(_dateOptionSelections[5], 'Custom', () {
              Utility.createModalSheet(
                  context,
                  Container(
                    height: 350,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildDatePicker((startDate, endDate) {
                        final date = Date(
                            DateUtility.removeTimeFromDate(startDate),
                            DateUtility.removeTimeFromDate(endDate));
                        setState(() {
                          setState(() {
                            //unselect the previously selected chip
                            _dateOptionSelections[
                                previousDateSelectedOptionIndex] = false;
                            previousDateSelectedOptionIndex = 5;
                            _dateOptionSelections[5] = true;
                            _fromDate = date.firstDate;
                            _toDate = date.lastDate;
                          });
                          databaseRepository.fetchByDateRange(date);
                        });
                      }),
                    ),
                  ),
                  enableDrag: true);
            })
          ],
        ),
      ]),
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
        onDateSelected(value.startDate!, value.endDate!);
        Navigator.of(context).pop();
      },
    );
    return datePicker;
  }

  Widget buildDateChoiceChip(bool selected, String text, Function onSelected) {
    return ChoiceChip(
      selected: selected,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: selected ? Colors.blue : Theme.of(context).canvasColor,
            width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      label: Text(
        text,
        style: TextStyle(
            color: selected ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.w500),
      ),
      selectedColor: const Color(0xC6F2FDFF),
      onSelected: (bool value) {
        onSelected();
      },
    );
  }

  @override
  void onRetrieveDatabase(List<CashBookModel> models) {
    if (!mounted) return;
    setState(() {
      _count = models.length;
      _toDate = DateUtility.removeTimeFromDate(DateTime.parse(models[0].date));
      _fromDate = DateUtility.removeTimeFromDate(
          DateTime.parse(models[models.length - 1].date));
      final cashRange = Utility.getMinAndMaxCash(models);
      _minCash = cashRange.first;
      _maxCash = cashRange.last;
      _startPrice = cashRange.first;
      _endPrice = cashRange.last;
      print('models are $_maxCash  $_minCash  $_startPrice  $_endPrice');
    });
  }

  @override
  void onDeleteAllDatabase(List<CashBookModel> emptyModel) {}

  @override
  void onInsertDatabase(List<CashBookModel> insertedModels) {}

  @override
  void onUpdateDatabase(List<CashBookModel> updatedModels) {}
}
