import 'package:flutter/cupertino.dart';

extension DelayedBackNavigation on BuildContext {
  void navigateBackWithDelay(int milliseconds, dynamic argument) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      Navigator.pop(this, argument);
    });
  }
}
