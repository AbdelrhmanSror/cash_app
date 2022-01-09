import 'package:debts_app/database/AppDataModel.dart';
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

  static int getSize(List<AppModel>? data) {
    //if the type is emptyApp model then this means the database is empty  and the call is from the database.
    //if the the data is empty  the call is not from the database
    //if the database is empty it will return emptyAppModel type class
    if (data != null && data[0] is! EmptyAppModel) {
      return data.length;
    } else {
      return 0;
    }
  }

  static bool fromDatabase(List<AppModel>? data) {
    //if the the data is empty and the call is not from the database
    if (data == null) {
      return false;
    } else {
      return true;
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
