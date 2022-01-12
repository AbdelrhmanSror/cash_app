import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/circularButton.dart';
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
            const Divider(height: 0, color: Colors.grey),
        itemBuilder: (BuildContext context, int index) => _buildRow(index));
  }

  Widget _buildEmptyWidget() {
    var opacity = 0.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
            opacity: opacity,
            child: AppTextWithDot(
              text: 'No Operations',
              color: Color(0xFACDCACA),
              fontSize: 12,
              fontWeight: FontWeight.normal,
            )),
        /*  const CircularProgressIndicator(
          strokeWidth: 3,
        ),*/
        Opacity(
            opacity: opacity,
            child: Column(
              children: [
                AppTextWithDot(
                  text: 'Add new operation',
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                Image.asset(
                  'assets/images/1f447.png',
                  width: 20,
                  height: 15,
                )
              ],
            ))
      ],
    );
  }

  Widget _buildRow(int index) {
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
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircularButton(
                  icon: (model.type == CASH_IN ? Icons.add : Icons.remove)),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                constraints: const BoxConstraints(minWidth: 1, maxWidth: 180),
                child: AppTextWithDot(
                    text: model.getFormattedDate(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF281361)),
              ),
              CompositeWidget(
                width: 150,
                widgets: [
                  AppTextWithDot(text: 'Balance ', color: Colors.grey),
                  AppTextWithDot(
                      text: '${(balance).abs()} EGP',
                      color: balance < 0 ? Colors.red : Colors.greenAccent)
                ],
              )
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              constraints: const BoxConstraints(minWidth: 1, maxWidth: 100),
              child: AppTextWithDot(
                  text: '${model.cash} EGP',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      model.type == CASH_OUT ? Colors.red : Colors.greenAccent),
            ),
            Text(model.type,
                style:
                    TextStyle(fontSize: 10, color: Colors.blueGrey.shade200)),
          ]),
        ],
      ),
    );
  }
}
