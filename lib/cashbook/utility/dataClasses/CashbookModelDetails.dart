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
      this.endDate = ''}) {
    print("");
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

  //setting group id in case we want to group items based on certain sortFilter
  CashBookModelListDetails applySort(SortFilter sortFilter) {
    final newSortedModels = models.toList();
    newSortedModels
        .sort((e1, e2) => applyItemSortComparator(sortFilter, e1, e2));
    for (int i = 1; i < newSortedModels.length; i++) {
      if (DateUtility.removeTimeFromDate(
              DateTime.parse(newSortedModels[i].date)) ==
          DateUtility.removeTimeFromDate(
              DateTime.parse(newSortedModels[i - 1].date))) {
        newSortedModels[i].groupId = newSortedModels[i - 1].groupId;
      } else {
        newSortedModels[i].groupId = newSortedModels[i - 1].groupId + 1;
      }
    }
    return CashBookModelListDetails(newSortedModels,
        totalCashIn: totalCashIn,
        totalCashOut: totalCashOut,
        startDate: startDate,
        endDate: endDate);
  }

  int applyItemSortComparator(
      SortFilter sortFilter, CashBookModel e1, CashBookModel e2) {
    if (sortFilter == SortFilter.older) {
      return e1.id.compareTo(e2.id);
    } else if (sortFilter == SortFilter.cashHighToLow) {
      return -1 * e1.cash.compareTo(e2.cash);
    } else if (sortFilter == SortFilter.cashLowToHigh) {
      return e1.cash.compareTo(e2.cash);
    } else {
      return -1 * e1.id.compareTo(e2.id);
    }
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
