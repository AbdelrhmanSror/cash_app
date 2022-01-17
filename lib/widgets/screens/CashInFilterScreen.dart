import 'package:debts_app/utility/DateUtility.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/functional/ExpandableWidget.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../main.dart';

class CashInFilterScreen extends StatefulWidget {
  CashInFilterScreen({required this.onDateSelected, Key? key})
      : super(key: key);

  Function(DateTime, DateTime) onDateSelected;

  @override
  _DateTimeState createState() => _DateTimeState();
}

class _DateTimeState extends State<CashInFilterScreen> {
  String fromDate = ' ';
  String toDate = ' ';

  //the variable that controls the height of the current widget on the screen.
  final double screenPercentage = 0.5;
  bool dateSelected = false;

  //variable represents the state of date filter options list arrow
  bool expanded = false;

  RangeValues price = RangeValues(0, 500000);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          elevation: 1,
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
                  MediaQuery.of(context).size.height * screenPercentage)),
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
                    text: const Text(
                      'Show 29 Results',
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
                        expanded = !expanded;
                      });
                    },
                    icon: Icon(expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded))
              ],
            ),
            buildDateSelection(expanded),
            buildDivider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: const Text(
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
      thickness: 1,
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
                label: Text('Cash: Low to High'),
                selected: true,
                onSelected: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: FilterChip(
                label: Text('Cash: High to low'),
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
            onSelected: (value) {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FilterChip(
            label: Text('Cash Out'),
            selected: false,
            onSelected: (value) {},
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
            data: const SliderThemeData(trackHeight: 1),
            child: RangeSlider(
                values: price,
                min: 0,
                max: 500000,
                divisions: 500000,
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${price.start.toInt()} EGP',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                '${price.end.toInt()} EGP',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
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
                    text: fromDate,
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
                    text: toDate,
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
            buildDateChoiceChip(true, 'This Week', () {
              setState(() {
                final date = DateUtility.getFirstAndLastDateInCurrentWeek();
                fromDate = date.firstDate;
                toDate = date.lastDate;
              });
              //fetch date by data in this week
              databaseRepository.fetchByDateRange(fromDate, toDate);
            }),
            buildDateChoiceChip(false, 'Last 7 Days', () {
              setState(() {
                final date = DateUtility.getFirstAndLastDateInLast7Days();
                fromDate = date.firstDate;
                toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(fromDate, toDate);
            }),
            buildDateChoiceChip(false, 'This Year', () {
              setState(() {
                final date = DateUtility.getFirstAndLastDateInCurrentYear();
                fromDate = date.firstDate;
                toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(fromDate, toDate);
            })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDateChoiceChip(false, 'Last 30 Days', () {
              setState(() {
                final date = DateUtility.getFirstAndLastDateInLast30Days();
                fromDate = date.firstDate;
                toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(fromDate, toDate);
            }),
            buildDateChoiceChip(false, 'Last Month', () {
              setState(() {
                final date = DateUtility.getFirstAndLastDateInLastMonth();
                fromDate = date.firstDate;
                toDate = date.lastDate;
              });
              databaseRepository.fetchByDateRange(fromDate, toDate);
            }),
            buildDateChoiceChip(false, 'Custom', () {
              Utility.createModalSheet(
                  context,
                  Container(
                    height: 350,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildDatePicker((startdate, endDate) {}),
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
      onSubmit: (selection) {
        //in case user did not enter the date complete.
        if (selection == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No Entered Date To Confirm!')));
        }
        final value = selection as PickerDateRange;
        if (value.startDate == null || value.endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No entered date To confirm!')));
        } else {
          //submit
          onDateSelected(value.startDate!, value.endDate!);
        }
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
}
