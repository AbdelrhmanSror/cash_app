import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';
import 'dataClasses/Cash.dart';
import 'dataClasses/Date.dart';

class FilterSharedPreferences {
  static void retrievedFilterPreferences(
      Function(Date? date, List<String>? type, CashRange? cashRange,
              SortFilter? sortFilter, DateFilter dateFilter)
          onReady) async {
    final prefs = await SharedPreferences.getInstance();
    final type = FilterSharedPreferences._getTypesFromPreferences(prefs);
    final sort = FilterSharedPreferences._getSortFromPreferences(prefs);
    final date = FilterSharedPreferences._getDateFromPreferences(prefs);
    final cash = FilterSharedPreferences._getCashRangeFromPreferences(prefs);
    final dateType = FilterSharedPreferences._getDateTypeFromPreferences(prefs);

    onReady(date, type, cash, sort, dateType);
  }

  static void setDateTypeInPreferences(DateFilter dateFilter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DATE, dateFilter.value);
  }

  static DateFilter _getDateTypeFromPreferences(SharedPreferences prefs) {
    final dateFilter = prefs.getString(DATE);
    if (dateFilter == null) {
      return DateFilter.CUSTOM;
    } else {
      return dateFilter.dateFilter;
    }
  }

  static void setTypesInPreferences(
      List<TypeFilter> typeFilters, OperationType operationType) async {
    final prefs = await SharedPreferences.getInstance();
    var types = prefs.getStringList(TYPE);
    for (var type in typeFilters) {
      if (types == null || types.isEmpty) {
        if (operationType == OperationType.INSERT) {
          types = [type.value];
          prefs.setStringList(TYPE, types);
        }
      } else {
        if (operationType == OperationType.INSERT &&
            !types.contains(type.value)) {
          types.add(type.value);
          prefs.setStringList(TYPE, types);
        }
        if (operationType == OperationType.DELETE) {
          types.removeAt(types.indexOf(type.value));
          prefs.setStringList(TYPE, types);
        }
      }
    }
  }

  static List<String> _getTypesFromPreferences(SharedPreferences prefs) {
    final type = prefs.getStringList(TYPE);
    if (type == null || type.isEmpty) {
      return [CASH_IN, CASH_OUT];
    }
    return type;
  }

  static void setSortInPreferences(SortFilter sortFilter) async {
    final prefs = await SharedPreferences.getInstance();
    if (sortFilter.value == LATEST) {
      prefs.setString(SORT, LATEST);
    } else if (sortFilter.value == OLDER) {
      prefs.setString(SORT, OLDER);
    } else if (sortFilter.value == CASH_HIGH_TO_LOW) {
      prefs.setString(SORT, CASH_HIGH_TO_LOW);
    } else if (sortFilter.value == CASH_LOW_TO_HIGH) {
      prefs.setString(SORT, CASH_LOW_TO_HIGH);
    }
  }

  static SortFilter _getSortFromPreferences(SharedPreferences prefs) {
    final sort = prefs.getString(SORT) ?? SortFilter.LATEST.value;
    if (sort == LATEST) {
      return SortFilter.LATEST;
    } else if (sort == OLDER) {
      return SortFilter.OLDER;
    } else if (sort == CASH_HIGH_TO_LOW) {
      return SortFilter.CASH_HIGH_TO_LOW;
    } else {
      return SortFilter.CASH_LOW_TO_HIGH;
    }
  }

  static void setDateInPreferences(Date date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DATE_START_RANGE, date.firstDate);
    prefs.setString(DATE_END_RANGE, date.lastDate);
  }

  static Date? _getDateFromPreferences(SharedPreferences prefs) {
    final startDate = prefs.getString(DATE_START_RANGE);
    final endDate = prefs.getString(DATE_END_RANGE);
    final date = (startDate == null || endDate == null)
        ? null
        : Date(startDate, endDate);
    return date;
  }

  static void setCashRangeInPreferences(
      SharedPreferences prefs, CashRange cashRange) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(CASH_START_RANGE, cashRange.first);
    prefs.setDouble(CASH_END_RANGE, cashRange.last);
  }

  static CashRange? _getCashRangeFromPreferences(SharedPreferences prefs) {
    final startCash = prefs.getDouble(CASH_START_RANGE);
    final endCash = prefs.getDouble(CASH_END_RANGE);
    final cash = (startCash == null || endCash == null)
        ? null
        : CashRange(startCash, endCash);
    return cash;
  }
}
