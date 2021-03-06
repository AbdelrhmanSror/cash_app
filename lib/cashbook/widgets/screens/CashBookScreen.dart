import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/InOutCashDetails.dart';
import 'package:debts_app/cashbook/widgets/functional/LineChart.dart';
import 'package:debts_app/cashbook/widgets/functional/OperationNumberWidget.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'FilterScreen.dart';
import 'ScreenNavigation.dart';

class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;

  MyCustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<MyCustomAppBar> createState() => _MyCustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyCustomAppBarState extends State<MyCustomAppBar> {
  bool _filterExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title,
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Color(0xFF3345A6), //change your color here
      ),
      centerTitle: true,
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
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 15, color: Color(0xFF3345A6)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 2),
                  child: Icon(
                    _filterExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF3345A6),
                    size: 16,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0x00ffffff),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildCard(
                      HeadLineChart(
                        modelListDetails: models,
                      ),
                    ),
                  ),
                  _buildCard(_buildInOutCashDetails()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOperationNumberWidget(),
                        IconButton(
                            onPressed: () async {
                              ScreenNavigation.navigateToCashListScreen(
                                  context);
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF3345A6),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  OperationNumberWidget _buildOperationNumberWidget() {
    return OperationNumberWidget(countNumber: models.models.length);
  }

  Widget _buildInOutCashDetails() => InOutCashDetails(models: models);

  @override
  void initState() {
    super.initState();
    //register this widget as listener to the any updates happen in the database
    databaseRepository.registerCashBookDatabaseListener(this);
    //retrieve all the data in the database to initialize our app
    databaseRepository.retrieveCashBooksForFirstTime();
  }

  @override
  void onDatabaseChanged(CashBookModelListDetails insertedModels) async {
    if (!mounted) return;
    setState(() {
      models = insertedModels.applyType(TypeFilter.all);
    });
    // });
  }

  @override
  void onDatabaseStarted(CashBookModelListDetails models) async {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      //initial setup for models
      //applying default sortFilter as Older
      this.models = models.applyType(TypeFilter.all);
    });
  }

  Widget _buildCard(Widget child) {
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


}
