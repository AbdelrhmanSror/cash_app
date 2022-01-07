import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CashInButtonWidget.dart';
import 'CashOutButtonWidget.dart';

class InOutCashButton extends StatelessWidget {
  const InOutCashButton(
      {required this.onCashInPressed, required this.onCashOutPressed, Key? key})
      : super(key: key);

  final Function() onCashInPressed;

  final Function() onCashOutPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CashInButton(onCashInPressed: onCashInPressed),
        const SizedBox(width: 16), // give it width
        CashOutButton(onCashOutPressed: onCashOutPressed)
      ],
    );
  }
}
