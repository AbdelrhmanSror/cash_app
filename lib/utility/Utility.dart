import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Utility {
  /*static String getTimeNow() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('E MMMM y ').format(now) +
        'at ' +
        DateFormat('Hm').format(now);
    return formattedDate;
  }*/


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

  static Future<void> createModalSheet(BuildContext context, Widget widget) {
    return showBarModalBottomSheet<void>(
      context: context,
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}
