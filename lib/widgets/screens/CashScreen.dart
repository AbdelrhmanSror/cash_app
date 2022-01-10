import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/main.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/Extensions.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CashInScreen extends CashScreen {
  CashInScreen({AppModel? modelToEdit, required operationType, Key? key})
      : super(
            operationType: operationType,
            key: key,
            modelToEdit: modelToEdit,
            cashFieldTextColor: Colors.greenAccent,
            cashFieldHintTextColor: Colors.greenAccent,
            validationButtonTextColor: Colors.green,
            validationButtonBackgroundColor: const Color(0xF5C0F8B2),
            type: CASH_IN);
}

class CashOutScreen extends CashScreen {
  CashOutScreen({AppModel? modelToEdit, required operationType, Key? key})
      : super(
            key: key,
            operationType: operationType,
            modelToEdit: modelToEdit,
            cashFieldTextColor: Colors.red,
            cashFieldHintTextColor: Colors.red,
            validationButtonTextColor: Colors.red,
            validationButtonBackgroundColor: const Color(0xCCFDF1F3),
            type: CASH_OUT);
}

abstract class CashScreen extends StatefulWidget {
  CashScreen(
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

  String operationType;
  final AppModel? modelToEdit;

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

  TextFormField cashNumberField() {
    var numberTextField = TextFormField(
      initialValue: widget.operationType == UPDATE
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
            initialValue: widget.operationType == UPDATE
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
    SchedulerBinding.instance?.addPostFrameCallback((Duration _) {
      _numberFieldFocusNode.requestFocus();
    });
    //if the operation type is update so we show the description textFormField
    //initially setup the value with the value in model in case user did no changes.
    if (widget.operationType == UPDATE) {
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
        if (numberText.isNotEmpty) {
          if (widget.operationType == INSERT) {
            appDatabase.insert(AppModel(
                date: '${DateTime.now()}',
                description: descriptionText,
                cash: (double.parse(numberText)),
                type: widget.type));
            FocusScope.of(context).unfocus();
            context.navigateBackWithDelay(200, '');
          } else {
            var updatedModel = appDatabase.updateModel(AppModel(
                totalCashIn: widget.modelToEdit!.totalCashIn,
                totalCashOut: widget.modelToEdit!.totalCashOut,
                date: widget.modelToEdit!.date,
                description: descriptionText,
                cash: (double.parse(numberText)),
                type: widget.type,
                id: widget.modelToEdit!.id));
            FocusScope.of(context).unfocus();
            //we delay the back to previous screen until keyboard is totally dismissed to prevent overflow render flex from happening
            context.navigateBackWithDelay(200, updatedModel);
          }
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
