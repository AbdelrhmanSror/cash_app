//class that has details of the total cash in and out for the current list of models,
// also has the start date and end date fro the entire list
//use this class if you want to know such information because it doesn't matter what is order of the list,
// the data is the same
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';

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

  //setting group id if we want to group items
  void _setGroupId(CashBookModelListDetails cashBookModelListDetails) {
    for (int i = 1; i < cashBookModelListDetails.models.length; i++) {
      if (DateUtility.removeTimeFromDate(
              DateTime.parse(cashBookModelListDetails.models[i].date)) ==
          DateUtility.removeTimeFromDate(
              DateTime.parse(cashBookModelListDetails.models[i - 1].date))) {
        cashBookModelListDetails.models[i].groupId =
            cashBookModelListDetails.models[i - 1].groupId;
      } else {
        cashBookModelListDetails.models[i].groupId =
            cashBookModelListDetails.models[i - 1].groupId + 1;
      }
    }
  }

  CashBookModelListDetails applyType(TypeFilter typeFilter) {
    //by default it retrieves all types from database.
    if (typeFilter == TypeFilter.all) return this;
    return CashBookModelListDetails(
        models.where((element) => element.type == typeFilter.value).toList(),
        totalCashIn: totalCashIn,
        totalCashOut: totalCashOut,
        startDate: startDate,
        endDate: endDate);
  }

  CashBookModelListDetails applySort(SortFilter sortFilter) {
    final CashBookModelListDetails cashBookModelDetails;
    if (sortFilter == SortFilter.older) {
      cashBookModelDetails = CashBookModelListDetails(models.toList(),
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    } else if (sortFilter == SortFilter.cashHighToLow) {
      cashBookModelDetails = CashBookModelListDetails(
          models..sort((a, b) => -1 * a.cash.compareTo(b.cash)),
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    } else if (sortFilter == SortFilter.cashLowToHigh) {
      cashBookModelDetails = CashBookModelListDetails(
          models..sort((a, b) => a.cash.compareTo(b.cash)),
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    } else {
      cashBookModelDetails = CashBookModelListDetails(models.reversed.toList(),
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    }
    //setting group id for list in case of grouping element
    _setGroupId(cashBookModelDetails);
    return cashBookModelDetails;
  }

  double getBalance() {
    return totalCashIn + totalCashOut;
  }

  double getPercentage() {
    var percentage = ((totalCashIn - totalCashOut.abs()) / totalCashOut.abs());
    if (percentage >= 1) percentage = 1;
    return percentage * 100;
  }
}
