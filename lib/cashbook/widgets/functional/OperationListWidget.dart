import 'dart:collection';

import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/widgets/functional/ExpandableWidget.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class OperationListWidget extends StatefulWidget {
  const OperationListWidget({required this.groupBy,
    required this.itemComparator,
    required this.models,
    this.onItemPressed,
    this.onDeletePressed,
    this.onEditPressed,
    this.onArchivePressed,
    required this.slideable,
    Key? key})
      : super(key: key);
  final int Function(CashBookModel element) groupBy;
  final int Function(CashBookModel element1, CashBookModel element2)
  itemComparator;

  //final int Function(int id1, int id2) groupComparator;
  final Function(CashBookModel)? onDeletePressed;
  final Function(CashBookModel)? onEditPressed;
  final Function(CashBookModel)? onArchivePressed;

  final List<CashBookModel> models;
  final Function(CashBookModel)? onItemPressed;
  final bool slideable;

  @override
  State<OperationListWidget> createState() => _OperationListWidgetState();
}

class _OperationListWidgetState extends State<OperationListWidget> {
  //map represent the state of group with id
  //if true then its expanded
  //if false then its not
  HashMap<int, bool> groupExpanded = HashMap();

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  Widget _buildSuggestions() {
    if (widget.models.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildEmptyWidget(),
      );
    }
    return buildStickyList();
  }

  Widget _buildEmptyWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppTextWithDot(
          text: 'No Operations',
          style: TextStyle(
              color: Color(0xFACDCACA),
              fontSize: 12,
              fontWeight: FontWeight.normal),
        ),
        /*  const CircularProgressIndicator(
          strokeWidth: 3,
        ),*/
        Column(
          children: [
            const AppTextWithDot(
              text: 'Add new operation',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/images/1f447.png',
              width: 20,
              height: 15,
            )
          ],
        )
      ],
    );
  }

  Widget buildStickyList() {
    // A rectangular area of a [Material] that responds to touch.
    return StickyGroupedListView<CashBookModel, int>(
      //creating new reference to list
      elements: widget.models,
      itemComparator: (x, y) => widget.itemComparator(x, y),
      groupBy: (CashBookModel element) => widget.groupBy(element),
      floatingHeader: true,
      groupSeparatorBuilder: (CashBookModel element) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: 35,
            child: Align(
              alignment: Alignment.center,
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    //reverse the state of expanded widget with list has id of group id
                    groupExpanded[element.groupId] =
                        !groupExpanded.putIfAbsent(element.groupId, () => true);
                  });
                },
                padding: const EdgeInsets.all(8),
                fillColor: const Color(0xFF3345A6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  DateUtility.getDateRepresentation(
                      DateTime.parse(element.date)),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ),
      itemBuilder: (_, CashBookModel element) {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            elevation: 4.0,
            child: ExpandableWidget(
              expand: groupExpanded.putIfAbsent(element.groupId, () => true),
              child: Slidable(
                enabled: widget.slideable,

                // Specify a key if the Slidable is dismissible.
                key: ValueKey(element.id),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(onDismissed: () {
                    try {
                      widget.onDeletePressed!(element);
                    } on NullThrownError catch (_, e) {}
                  }),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (_) {
                        try {
                          widget.onDeletePressed!(element);
                        } on NullThrownError catch (_, e) {}
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (_) {
                        try {
                          widget.onEditPressed!(element);
                        } on NullThrownError catch (_, e) {}
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Edit',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 2,
                      onPressed: (_) {
                        try {
                          widget.onArchivePressed!(element);
                        } on NullThrownError catch (_, e) {}
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.archive,
                      label: 'Archive',
                    ),
                  ],
                ),

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: InkWell(
                    child: OperationTile(model: element),
                    onTap: () {
                      try {
                        widget.onItemPressed!(element);
                      } on NullThrownError catch (_, e) {}
                    }),
              ),
            ));
      },
    );
  }
}

class OperationTile extends StatelessWidget {
  const OperationTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final CashBookModel model;

  @override
  Widget build(BuildContext context) {
    final double balance = model.getBalance();
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              (model.type == TypeFilter.cashIn.value
                  ? Icons.add
                  : Icons.remove),
              color: model.type == TypeFilter.cashOut.value
                  ? const Color(0xFFF64E57)
                  : const Color(0xFF08A696),
              size: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 16, left: 16, right: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      constraints:
                      const BoxConstraints(maxWidth: 200, minWidth: 1),
                      alignment: Alignment.centerLeft,
                      child: AppTextWithDot(
                        text:
                        'EGP ${Utility.formatCashNumber(model.cash.abs())}',
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  CompositeWidget(
                    width: 100,
                    widgets: [
                      const AppTextWithDot(
                        text: 'Balance ',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      ),
                      AppTextWithDot(
                          text:
                          'EGP ${Utility.formatCashNumber((balance.abs()))}',
                          style: TextStyle(
                              color: balance < 0
                                  ? const Color(0xFFF56B73)
                                  : const Color(0xFF09C7B4),
                              fontWeight: FontWeight.normal,
                              fontSize: 10))
                    ],
                  )
                ]),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8),
          child: Column(
            children: [
              AppTextWithDot(
                text: DateUtility.getTimeRepresentation(
                    DateTime.parse(model.date)),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              Row(
                children: [
                  Text(
                    model.type,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    model.type == TypeFilter.cashOut.value
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: model.type == TypeFilter.cashOut.value
                        ? const Color(0xFFF88D93)
                        : const Color(0xFF60C8C8),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
