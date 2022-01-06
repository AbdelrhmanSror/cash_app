import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/partialWidgets/AppTextWithDots.dart';
import 'package:debts_app/widgets/partialWidgets/CompositeTextWidget.dart';
import 'package:debts_app/widgets/partialWidgets/circularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OperationListWidget extends StatefulWidget {
  OperationListWidget({required this.models, required this.height, Key? key})
      : super(key: key);
  final List<AppModel> models;
  final double height;

  @override
  State<OperationListWidget> createState() => _OperationListWidgetState();
}

class _OperationListWidgetState extends State<OperationListWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double abovePadding = MediaQuery.of(context).padding.top;
    double appBarHeight = 50;
    double leftHeight = screenHeight - abovePadding - appBarHeight;
    double height50 = leftHeight * 0.3;

    return SizedBox(
      width: double.infinity,
      height: height50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildSuggestions(),
      ),
    );
  }

  Widget _buildSuggestions() {
    int count = Utility.getSize(widget.models);
    print('SIZE IS $count');
    if (count == 0) return _buildEmptyWidget();
    return ListView.separated(
        itemCount: count,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 0, color: Colors.grey),
        itemBuilder: (BuildContext context, int index) => _buildRow(index));
  }

  Widget _buildEmptyWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextWithDot(
          text: 'No Operations',
          color: Color(0xFACDCACA),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        CircularProgressIndicator(
          strokeWidth: 3,
        ),
        Column(
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
        )
      ],
    );
  }

  Widget _buildRow(int index) {
    final double balance =
        widget.models[index].totalCashIn - widget.models[index].totalCashOut;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const CircularButton(icon: Icons.add_outlined),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              constraints: const BoxConstraints(minWidth: 1, maxWidth: 180),
              child: AppTextWithDot(
                  text: widget.models[index].date,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF281361)),
            ),
            CompositeTextWidget(
              width: 150,
              texts: [
                AppTextWithDot(text: 'Balance', color: Colors.grey),
                AppTextWithDot(
                    text: '${(balance).abs()} EGP',
                    color: balance < 0 ? Colors.red : Colors.greenAccent)
              ],
            )
          ])
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            constraints: const BoxConstraints(minWidth: 1, maxWidth: 100),
            child: AppTextWithDot(
                text: '${widget.models[index].cash} EGP',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: widget.models[index].type == CASH_OUT
                    ? Colors.red
                    : Colors.greenAccent),
          ),
          Text(widget.models[index].type,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ]),
      ],
    );
  }
}
