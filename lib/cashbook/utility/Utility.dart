import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Utility {
  static String formatCashNumber(double number) {
    var formatter = NumberFormat('##,###,000');
    if (number.abs() < 100) {
      if (number.abs() < 10) {
        formatter = NumberFormat('#,###,0');
      } else {
        formatter = NumberFormat('#,###,00');
      }
    }
    return formatter.format(number);
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

  static void showKeyboard(FocusNode focusNode, {int duration = 50}) {
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
