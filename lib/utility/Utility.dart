import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dataClasses/Cash.dart';

class Utility {
  static Route createAnimationRoute(
      Widget destinationWidget, Offset begin, Offset end, Curve curve) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      opaque: true,
      pageBuilder: (context, animation, secondaryAnimation) =>
      destinationWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  static CashRange getMinAndMaxCash(List<CashBookModel> models) {
    var min = models[0].cash;
    var max = models[0].cash;
    for (var elements in models) {
      if (elements.cash < min) min = elements.cash;
      if (elements.cash > max) max = elements.cash;
    }
    return CashRange(min, max);
  }

  static void showKeyboard(FocusNode focusNode, {int duration = 500}) {
    SchedulerBinding.instance?.addPostFrameCallback((Duration _) {
      Future.delayed(Duration(milliseconds: duration), () {
        focusNode.requestFocus();
      });
    });
  }

  static Future<void> createModalSheet(BuildContext context, Widget widget,
      {bool enableDrag = true}) {
    return showBarModalBottomSheet<void>(
      context: context,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      barrierColor: Colors.transparent.withOpacity(0.7),
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}
