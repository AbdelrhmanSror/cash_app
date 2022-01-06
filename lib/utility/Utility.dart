import 'package:debts_app/database/AppDataModel.dart';
import 'package:intl/intl.dart';

class Utility {
  static String getTimeNow() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM y ').format(now) +
        'at ' +
        DateFormat('Hm').format(now);
    return formattedDate;
  }

  static double getBalance(AppModel model) {
    final double balance = model.totalCashIn - model.totalCashOut;
    return balance;
  }

  static int getSize(List<AppModel> data) {
    //if the type is emptyApp model then this means the database is empty .
    if (data[0] is! EmptyAppModel) {
      return data.length;
    } else {
      return 0;
    }
  }
}
