import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/circularButton.dart';
import 'package:flutter/material.dart';

class OperationListWidget extends StatefulWidget {
  const OperationListWidget(
      {required this.models, required this.onPressed, Key? key})
      : super(key: key);

  final List<AppModel>? models;
  final Function(AppModel) onPressed;

  @override
  State<OperationListWidget> createState() => _OperationListWidgetState();
}

class _OperationListWidgetState extends State<OperationListWidget> {
  bool _showLoadingBar = false;

  @override
  void initState() {
    super.initState();
    print('INITIALIZE STATE OF LIST');
  }

  @override
  Widget build(BuildContext context) {
    print('BUILDING OF LIST');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    int count = Utility.getSize(widget.models);
    print('SIZE IS $count');
    if (!Utility.fromDatabase(widget.models)) {
      _showLoadingBar = true;
    } else {
      _showLoadingBar = false;
    }
    if (count == 0) return _buildEmptyWidget();
    return ListView.separated(
        itemCount: count,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 0, color: Colors.grey),
        itemBuilder: (BuildContext context, int index) => _buildRow(index));
  }

  Widget _buildEmptyWidget() {
    var opacity = 0.0;
    if (!_showLoadingBar) opacity = 1;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
            opacity: opacity,
            child: AppTextWithDot(
              text: 'No Operations',
              color: const Color(0xFACDCACA),
              fontSize: 12,
              fontWeight: FontWeight.normal,
            )),
        Visibility(
            visible: _showLoadingBar,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
            )),
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
        child: OperationTile(model: widget.models![index]),
        onTap: () {
          widget.onPressed(widget.models![index]);
        });
  }
}

class OperationTile extends StatelessWidget {
  const OperationTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final AppModel model;

  @override
  Widget build(BuildContext context) {
    final double balance = model.totalCashIn - model.totalCashOut;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const CircularButton(icon: Icons.add_outlined),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.only(bottom: 8),
              constraints: const BoxConstraints(minWidth: 1, maxWidth: 180),
              child: AppTextWithDot(
                  text: model.date,
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
            padding: EdgeInsets.only(bottom: 8),
            constraints: const BoxConstraints(minWidth: 1, maxWidth: 100),
            child: AppTextWithDot(
                text: '${model.cash} EGP',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color:
                    model.type == CASH_OUT ? Colors.red : Colors.greenAccent),
          ),
          Text(model.type,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ]),
      ],
    );
  }
}
