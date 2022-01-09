import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClosedBookAlertScreen extends StatelessWidget {
  const ClosedBookAlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
                minWidth: double.infinity, maxWidth: double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AppTextWithDot(
                    text: 'Cashbook closed!',
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(
                  child: AppTextWithDot(
                    text:
                        'You can see all your operations in Operations archive',
                    color: Colors.grey,
                    fontSize: 14,
                    maxLines: 2,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(
                minWidth: double.infinity, maxWidth: double.infinity),
            child: RoundedButton(
              text: AppTextWithDot(
                  text: 'CLOSE',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white),
              backgroundColor: Colors.redAccent,
              radius: 5.0,
              paddingTop: 16,
              paddingBottom: 16,
              paddingLeft: 16,
              paddingRight: 16,
              onPressed: () {
                Navigator.pop(context, '');
              },
            ),
          ),
        ),
      ]),
    );
  }
}
