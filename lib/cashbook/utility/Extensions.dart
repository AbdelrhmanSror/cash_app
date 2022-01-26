import 'package:flutter/cupertino.dart';

import 'DateUtility.dart';

extension DelayedBackNavigation on BuildContext {
  void navigateBackWithDelay(int milliseconds, dynamic argument) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      Navigator.pop(this, argument);
    });
  }
}

extension FormattedDate on String {
  String getFormattedDate() {
    return DateUtility.getDateRepresentation(DateTime.parse(this));
  }
}

extension FormattedDate2 on String {
  String getFormattedDateTime() {
    return DateUtility.getDateTimeRepresentation(DateTime.parse(this));
  }
}

extension FormattedDate3 on String {
  String getFormattedDateTime2() {
    return DateUtility.getDateTimeRepresentation2(DateTime.parse(this));
  }
}
