import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/main.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

class CashInScreen extends CashScreen {
  const CashInScreen({Key? key})
      : super(
            key: key,
            cashFieldTextColor: Colors.greenAccent,
            cashFieldHintTextColor: Colors.greenAccent,
            validationButtonTextColor: Colors.green,
            validationButtonBackgroundColor: const Color(0xF5C0F8B2),
            type: CASH_IN);
}

class CashOutScreen extends CashScreen {
  const CashOutScreen({Key? key})
      : super(
            key: key,
            cashFieldTextColor: Colors.red,
            cashFieldHintTextColor: Colors.red,
            validationButtonTextColor: Colors.red,
            validationButtonBackgroundColor: const Color(0xCCFDF1F3),
            type: CASH_OUT);
}

abstract class CashScreen extends StatefulWidget {
  const CashScreen(
      {required this.cashFieldTextColor,
      required this.cashFieldHintTextColor,
      required this.validationButtonTextColor,
      required this.validationButtonBackgroundColor,
      required this.type,
      Key? key})
      : super(key: key);
  final Color cashFieldTextColor;

  final Color cashFieldHintTextColor;

  final Color validationButtonTextColor;

  final Color validationButtonBackgroundColor;

  final String type;

  @override
  State<CashScreen> createState() {
    return _CashScreenState();
  }
}

class _CashScreenState extends State<CashScreen> {
  final _numberFieldController = TextEditingController();
  final _detailsFieldController = TextEditingController();

  var opacity = 0.0;

  TextField cashNumberField() {
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
      style: TextStyle(
          color: widget.cashFieldTextColor,
          fontSize: 30,
          fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      onSubmitted: (text) {},
      decoration: InputDecoration.collapsed(
          hintStyle:
              TextStyle(fontSize: 30.0, color: widget.cashFieldHintTextColor),
          hintText: '0.00 EGP'),
    );
  }

  Widget buildCashDetailsFieldWidget() {
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
        title: Text(
          widget.type.toUpperCase(),
          style: const TextStyle(
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
                buildCashFieldWidget(),
                buildCashDetailsFieldWidget(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: Container(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, maxWidth: double.infinity),
                child: buildValidateButton(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  RoundedButton buildValidateButton(BuildContext context) {
    return RoundedButton(
      text: AppTextWithDot(
          text: 'VALIDATE',
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: widget.validationButtonTextColor),
      backgroundColor: widget.validationButtonBackgroundColor,
      radius: 5.0,
      paddingTop: 16,
      paddingBottom: 16,
      paddingLeft: 16,
      paddingRight: 16,
      onPressed: () {
        if (_numberFieldController.text.isNotEmpty) {
          database.insert(AppModel(
              date: Utility.getTimeNow(),
              description: _detailsFieldController.text,
              cash: (double.parse(_numberFieldController.text)),
              type: widget.type));
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Enter the ${widget.type} amount!')));
        }
      },
    );
  }

  CompositeWidget buildCashFieldWidget() {
    return CompositeWidget(
        width: double.infinity,
        widgets: [
          AppTextWithDot(
              text: widget.type,
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal),
          cashNumberField()
        ],
        vertical: true);
  }
}
