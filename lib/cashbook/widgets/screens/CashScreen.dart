import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/Extensions.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/cashbook/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class CashInScreen extends CashScreen {
   CashInScreen({CashBookModel? modelToEdit, required operationType, Key? key})
      : super(
            operationType: operationType,
            key: key,
            modelToEdit: modelToEdit,
            cashFieldTextColor: Colors.greenAccent,
            cashFieldHintTextColor: Colors.greenAccent,
            validationButtonTextColor: Colors.green,
            validationButtonBackgroundColor: const Color(0xF5C0F8B2),
            type: TypeFilter.cashIn.value);
}

class CashOutScreen extends CashScreen {
  CashOutScreen({CashBookModel? modelToEdit, required operationType, Key? key})
      : super(
            key: key,
            operationType: operationType,
            modelToEdit: modelToEdit,
            cashFieldTextColor: Colors.red,
            cashFieldHintTextColor: Colors.red,
            validationButtonTextColor: Colors.red,
            validationButtonBackgroundColor: const Color(0xCCFDF1F3),
            type: TypeFilter.cashOut.value);
}

abstract class CashScreen extends StatefulWidget {
  const CashScreen(
      {required this.cashFieldTextColor,
      required this.cashFieldHintTextColor,
      required this.validationButtonTextColor,
      required this.validationButtonBackgroundColor,
      required this.type,
      required this.operationType,
      this.modelToEdit,
      Key? key})
      : super(key: key);
  final Color cashFieldTextColor;

  final Color cashFieldHintTextColor;

  final Color validationButtonTextColor;

  final Color validationButtonBackgroundColor;

  final String type;

  final OperationType operationType;
  final CashBookModel? modelToEdit;

  @override
  State<CashScreen> createState() {
    return _CashScreenState();
  }
}

class _CashScreenState extends State<CashScreen> {
  final _numberFieldFocusNode = FocusNode();
  double opacity = 0.0;
  String numberText = '';
  String descriptionText = '';
  TextFormField _cashNumberField() {
    var numberTextField = TextFormField(
      initialValue: widget.operationType == OperationType.update
          ? widget.modelToEdit?.cash.toString()
          : null,
      focusNode: _numberFieldFocusNode,
      onChanged: (text) {
        if (text.isEmpty) {
          setState(() {
            numberText = '';
            opacity = 0.0;
          });
        } else {
          setState(() {
            numberText = text;
            opacity = 1.0;
          });
        }
      },
      style: TextStyle(
          color: widget.cashFieldTextColor,
          fontSize: 30,
          fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      decoration: InputDecoration.collapsed(
          hintStyle:
              TextStyle(fontSize: 30.0, color: widget.cashFieldHintTextColor),
          hintText: '0.00 EGP'),
    );
    return numberTextField;
  }

  Widget buildCashDetailsFieldWidget() {
    var detailsTextField = Opacity(
        opacity: opacity,
        child: TextFormField(
            initialValue: widget.operationType == OperationType.update
                ? widget.modelToEdit?.description
                : null,
            enabled: opacity >= 1.0,
            onChanged: (text) {
              if (text.isEmpty) {
                setState(() {
                  descriptionText = '';
                });
              } else {
                setState(() {
                  descriptionText = text;
                });
              }
            },
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Details (article ,invoice number, quantity...)')));

    return detailsTextField;
  }

  @override
  void initState() {
    super.initState();
    //to immediately show keyboard of cashNumber field after build finish
    Utility.showKeyboard(_numberFieldFocusNode);
    //if the operation type is update so we show the description textFormField
    //initially setup the value with the value in model in case user did no changes.
    if (widget.operationType == OperationType.update) {
      setState(() {
        numberText = widget.modelToEdit!.cash.toString();
        descriptionText = widget.modelToEdit!.description.toString();
        opacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
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
                _buildCashFieldWidget(),
                buildCashDetailsFieldWidget(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: Container(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, maxWidth: double.infinity),
                child: _buildValidateButton(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  RoundedTextButton _buildValidateButton(BuildContext context) {
    return RoundedTextButton(
      text: AppTextWithDot(
        text: 'VALIDATE',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: widget.validationButtonTextColor),
      ),
      backgroundColor: widget.validationButtonBackgroundColor,
      radius: 5.0,
      paddingTop: 16,
      paddingBottom: 16,
      paddingLeft: 16,
      paddingRight: 16,
      onPressed: () async {
        if (numberText.isNotEmpty) {
          if (widget.operationType == OperationType.insert) {
            await databaseRepository.insertCashBook(CashBookModel(
                date: '${DateTime.now() /*.subtract(Duration(days: 3))*/}',
                description: descriptionText,
                cash: (widget.type == TypeFilter.cashIn.value
                    ? double.parse(numberText)
                    : -double.parse(numberText)),
                type: widget.type));
            FocusScope.of(context).unfocus();
            context.navigateBackWithDelay(200, '');
          }
          if (widget.operationType == OperationType.update) {
            await databaseRepository.updateCashBook(CashBookModel(
                totalCashIn: widget.modelToEdit!.totalCashIn,
                totalCashOut: widget.modelToEdit!.totalCashOut,
                date: widget.modelToEdit!.date,
                description: descriptionText,
                cash: (widget.type == TypeFilter.cashIn.value
                    ? double.parse(numberText)
                    : -double.parse(numberText)),
                type: widget.type,
                id: widget.modelToEdit!.id));
            FocusScope.of(context).unfocus();
            //we delay the back to previous screen until keyboard is totally dismissed to prevent overflow render flex from happening
            context.navigateBackWithDelay(200, '');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Enter the ${widget.type} amount!')));
        }
      },
    );
  }

  CompositeWidget _buildCashFieldWidget() {
    return CompositeWidget(
        width: double.infinity,
        widgets: [
          AppTextWithDot(
            text: widget.type,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          _cashNumberField()
        ],
        vertical: true);
  }
}
