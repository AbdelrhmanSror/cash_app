import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class OperationListWidget extends StatefulWidget {
  const OperationListWidget(
      {required this.models, required this.onPressed, Key? key})
      : super(key: key);

  final List<CashBookModel> models;
  final Function(CashBookModel) onPressed;

  @override
  State<OperationListWidget> createState() => _OperationListWidgetState();
}

class _OperationListWidgetState extends State<OperationListWidget> {
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
    return StickyGroupedListView<CashBookModel, String>(
      elements: widget.models,
      groupBy: (CashBookModel element) =>
          DateUtility.removeTimeFromDate(DateTime.parse(element.date)),
      groupComparator: (String value1, String value2) =>
          value2.compareTo(value1),
      itemComparator: (CashBookModel element1, CashBookModel element2) =>
          DateUtility.removeTimeFromDate(DateTime.parse(element1.date))
              .compareTo(DateUtility.removeTimeFromDate(
                  DateTime.parse(element2.date))),
      floatingHeader: true,
      groupSeparatorBuilder: (CashBookModel element) => SizedBox(
        height: 35,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF3345A6),
              border: Border.all(
                color: const Color(0xFF3345A6),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateUtility.getAlphabeticDate(DateTime.parse(element.date)),
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      itemBuilder: (_, CashBookModel element) {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            elevation: 4.0,
            child: Slidable(
              // Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),

              // The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: const [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.share,
                    label: 'Share',
                  ),
                ],
              ),

              // The end action pane is the one at the right or the bottom side.
              endActionPane: const ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 2,
                    onPressed: null,
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                ],
              ),

              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: InkWell(
                  child: OperationTile(model: element),
                  onTap: () {
                    widget.onPressed(element);
                  }),
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
            padding: const EdgeInsets.only(left: 16),
            child: Icon(
              (model.type == CASH_IN ? Icons.add : Icons.remove),
              color: model.type == CASH_OUT
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
                          const BoxConstraints(maxWidth: 100, minWidth: 1),
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
          padding: const EdgeInsets.only(right: 16.0, top: 8),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 1, maxWidth: 180),
                child: AppTextWithDot(
                  text:
                      '${DateUtility.getTimeRepresentation(DateTime.parse(model.date))}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black),
                ),
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
                    model.type == CASH_OUT
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: model.type == CASH_OUT
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
