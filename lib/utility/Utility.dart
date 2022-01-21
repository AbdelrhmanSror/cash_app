import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'Constants.dart';
import 'dataClasses/Cash.dart';

class Utility {
  //get the type of current sorting mechanism of the app ,
  //if it was latest then the we can get the total cash in out from first position in the list because it accumulates all the data before
  //other wise we get it from the last position of the list;
  static CashRange getTotalCashInOut(List<CashBookModel> models) {
    var temptype = SortFilter.LATEST;
    if (temptype == SortFilter.LATEST) {
      return CashRange(models[0].totalCashIn, models[0].totalCashOut);
    } else {
      return CashRange(models[models.length - 1].totalCashIn,
          models[models.length - 1].totalCashOut);
    }
  }

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
    if (models.isEmpty) return CashRange(0, 0);
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
      {bool enableDrag = true, VoidCallback? onComplete}) {
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
    ).whenComplete(() {
      if (onComplete != null) {
        onComplete();
      }
    });
  }
}
