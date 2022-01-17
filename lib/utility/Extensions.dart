import 'package:debts_app/utility/DateUtility.dart';
import 'package:flutter/cupertino.dart';

extension DelayedBackNavigation on BuildContext {
  void navigateBackWithDelay(int milliseconds, dynamic argument) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      Navigator.pop(this, argument);
    });
  }
}

extension FormattedDate on String {
  String getFormattedDate() {
    return DateUtility.getDateTimeRepresentation(DateTime.parse(this));
  }
}
