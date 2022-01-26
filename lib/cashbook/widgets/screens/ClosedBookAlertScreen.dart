import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

class ClosedBookAlertScreen extends StatefulWidget {
  const ClosedBookAlertScreen({Key? key}) : super(key: key);

  @override
  State<ClosedBookAlertScreen> createState() => _ClosedBookAlertScreenState();
}

class _ClosedBookAlertScreenState extends State<ClosedBookAlertScreen> {
  bool _disposed = false;

  void navigateAfter(int milliSeconds) {
    Future.delayed(Duration(milliseconds: milliSeconds), () {
      //to prevent navigator from navigate back twice ,
      // because of the conflict between this navigator and the navigator exist in on pressed close button
      if (_disposed != true) Navigator.pop(context, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    //wait 2 second and dismiss the the screen
    navigateAfter(3000);
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
                minWidth: double.infinity, maxWidth: double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: AppTextWithDot(
                    text: 'Cashbook closed!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: AppTextWithDot(
                    text:
                        'You can see all your operations in Operations archive',
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
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
            child: RoundedTextButton(
              text: const AppTextWithDot(
                text: 'CLOSE',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.white),
              ),
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

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
