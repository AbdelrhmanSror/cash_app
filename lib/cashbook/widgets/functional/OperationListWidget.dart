import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/Extensions.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/cashbook/widgets/partial/circularButton.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    if (widget.models.isEmpty) return _buildEmptyWidget();
    return ListView.separated(
        itemCount: widget.models.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(color: Colors.grey),
        itemBuilder: (BuildContext context, int index) => _buildRow(index));
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

  Widget _buildRow(int index) {
    // A rectangular area of a [Material] that responds to touch.
    return InkWell(
        child: OperationTile(model: widget.models[index]),
        onTap: () {
          widget.onPressed(widget.models[index]);
        });
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
    final double balance = model.totalCashIn - model.totalCashOut;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircularButton(
              icon: (model.type == CASH_IN ? Icons.add : Icons.remove),
              backgroundColor: model.type == CASH_OUT
                  ? Color(0xFFF64E57)
                  : Color(0xFF08A696),
              iconColor: Colors.white,
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              constraints: const BoxConstraints(minWidth: 1, maxWidth: 180),
              child: AppTextWithDot(
                text: model.date.getFormattedDate(),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
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
                    text: 'EGP ${(balance).abs()}',
                    style: TextStyle(
                        color: balance < 0 ? Colors.red : Colors.greenAccent,
                        fontWeight: FontWeight.normal,
                        fontSize: 10))
              ],
            )
          ])
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100,
                alignment: Alignment.centerRight,
                child: AppTextWithDot(
                  text: 'EGP ${model.cash}',
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              Icon(
                model.type == CASH_OUT
                    ? Icons.arrow_drop_down
                    : Icons.arrow_drop_up,
                color: model.type == CASH_OUT
                    ? Color(0xFFF88D93)
                    : Color(0xFF60C8C8),
              )
            ],
          ),
          Text(model.type,
              style: TextStyle(fontSize: 10, color: Colors.blueGrey.shade200)),
        ]),
      ],
    );
  }
}
