import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/main.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/partialWidgets/AppTextWithDots.dart';
import 'package:debts_app/widgets/partialWidgets/CompositeWidget.dart';
import 'package:debts_app/widgets/partialWidgets/RoundedButton.dart';
import 'package:flutter/material.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({Key? key}) : super(key: key);

  @override
  State<CashInScreen> createState() {
    return _CashInScreenState();
  }
}

class _CashInScreenState extends State<CashInScreen> {
  final _numberFieldController = TextEditingController();
  final _detailsFieldController = TextEditingController();

  var opacity = 0.0;

  TextField cashInNumberField() {
    return TextField(
      controller: _numberFieldController,
      onChanged: (text) {
        if (text.isEmpty) {
          setState(() {
            opacity = 0.0;
          });
        } else {
          setState(() {
            opacity = 1.0;
          });
        }
      },
      style: const TextStyle(
          color: Colors.greenAccent, fontSize: 30, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      onSubmitted: (text) {},
      decoration: const InputDecoration.collapsed(
          hintStyle: TextStyle(fontSize: 30.0, color: Colors.greenAccent),
          hintText: '0.00 EGP'),
    );
  }

  Widget cashInDetailsField() {
    return Opacity(
        opacity: opacity,
        child: TextFormField(
            controller: _detailsFieldController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Details (article ,invoice number, quantity...)')));
  }

  @override
  void dispose() {
    super.dispose();
    _numberFieldController.clear();
    _detailsFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.blue, //change your color here
        ),
        title: const Text(
          'CASH IN',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CompositeWidget(
                    width: double.infinity,
                    widgets: [
                      AppTextWithDot(
                          text: 'Cash in',
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                      cashInNumberField()
                    ],
                    vertical: true),
                cashInDetailsField(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: Container(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, maxWidth: double.infinity),
                child: RoundedButton(
                  text: AppTextWithDot(
                      text: 'VALIDATE',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.green),
                  backgroundColor: const Color(0xF5C0F8B2),
                  radius: 5.0,
                  padding_top: 16,
                  padding_bottom: 16,
                  padding_left: 16,
                  padding_right: 16,
                  onPressed: () {
                    if (_numberFieldController.text.isNotEmpty) {
                      database.insert(AppModel(
                          date: Utility.getTimeNow(),
                          description: _detailsFieldController.text,
                          cash: (double.parse(_numberFieldController.text)),
                          type: CASH_IN));
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Enter the Cash In amount!')));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
