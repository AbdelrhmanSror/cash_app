//class that has details of the total cash in and out for the current list of models,
// also has the start date and end date fro the entire list
//use this class if you want to know such information because it doesn't matter what is order of the list,
// the data is the same
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';

import '../Constants.dart';

class CashBookModelListDetails {
  final List<CashBookModel> models;
  final double totalCashIn;

  final double totalCashOut;
  final String startDate;

  final String endDate;

  CashBookModelListDetails(this.models,
      {this.totalCashIn = 0,
      this.totalCashOut = 0,
      this.startDate = '',
      this.endDate = ''});

  double getBalance() {
    return totalCashIn - totalCashOut;
  }

  double getMaxCashIn() {
    var maxCashIn = 0.0;
    for (var model in models) {
      if (model.type == CASH_IN && model.cash > maxCashIn) {
        maxCashIn = model.cash;
      }
    }
    return maxCashIn;
  }

  double getMaxCashOut() {
    var maxCashOut = 0.0;
    for (var model in models) {
      if (model.type == CASH_OUT && model.cash > maxCashOut) {
        maxCashOut = model.cash;
      }
    }
    return maxCashOut;
  }

  double getPercentage() {
    return ((totalCashIn - totalCashOut) / totalCashOut) * 100;
  }
}
