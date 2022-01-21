import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';
import 'dataClasses/Cash.dart';
import 'dataClasses/Date.dart';

class FilterSharedPreferences {
  static void retrievedFilterPreferences(
      Function(Date? date, TypeFilter? type, CashRange? cashRange,
              SortFilter? sortFilter)
          onReady) async {
    final prefs = await SharedPreferences.getInstance();
    final type = _getTypesFromPreferences(prefs);
    final sort = _getSortFromPreferences(prefs);
    final date = _getDateFromPreferences(prefs);
    final cash = _getCashRangeFromPreferences(prefs);

    onReady(date, type, cash, sort);
  }

  static Future<void> setDateTypeInPreferences(DateFilter dateFilter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DATE, dateFilter.value);
  }

  static Future<DateFilter?> getDateTypeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dateFilter = prefs.getString(DATE);
    if (dateFilter == null) {
      return null;
    } else {
      return dateFilter.dateFilter;
    }
  }

  static Future<void> setTypesInPreferences(TypeFilter typeFilter) async {
    final prefs = await SharedPreferences.getInstance();
    final previousType = _getTypesFromPreferences(prefs);
    //if the type exist in the prefs then delete it
    if (previousType == typeFilter) {
      prefs.remove(TYPE);
    } else {
      prefs.setString(TYPE, typeFilter.value);
    }
  }

  static TypeFilter? _getTypesFromPreferences(SharedPreferences prefs) {
    final type = prefs.getString(TYPE);
    return type?.typeFilter;
  }

  static Future<void> setSortInPreferences(SortFilter sortFilter) async {
    final prefs = await SharedPreferences.getInstance();
    final previousSort = _getSortFromPreferences(prefs);
    //if the type exist in the prefs then delete it
    if (previousSort == sortFilter) {
      prefs.remove(SORT);
    } else {
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
  }

  static SortFilter? _getSortFromPreferences(SharedPreferences prefs) {
    //by default data is sorted in descending order.
    final sort = prefs.getString(SORT);
    if (sort == LATEST) {
      return SortFilter.LATEST;
    } else if (sort == OLDER) {
      return SortFilter.OLDER;
    } else if (sort == CASH_HIGH_TO_LOW) {
      return SortFilter.CASH_HIGH_TO_LOW;
    } else if (sort == CASH_LOW_TO_HIGH) {
      return SortFilter.CASH_LOW_TO_HIGH;
    } else {
      return null;
    }
  }

  static Future<void> setDateInPreferences(Date date) async {
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

  static Future<void> setCashRangeInPreferences(
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

  static Future<void> flipArrowState(FilterArrowState filterArrowState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final previousState = await getArrowState(filterArrowState);
    preferences.setBool(filterArrowState.value, !previousState);
  }

  static Future<bool> getArrowState(FilterArrowState filterArrowState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(filterArrowState.value) ?? true;
  }

  static Future<void> clearFilter() async {
    //clear all data in preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(SORT);
    preferences.remove(TYPE);
    preferences.remove(CASH_START_RANGE);
    preferences.remove(CASH_END_RANGE);
    preferences.remove(DATE_START_RANGE);
    preferences.remove(DATE_END_RANGE);
    preferences.remove(DATE);
    preferences.remove(FilterArrowState.SORT_ARROW.value);
    preferences.remove(FilterArrowState.DATE_ARROW.value);
    preferences.remove(FilterArrowState.TYPE_ARROW.value);
    preferences.remove(FilterArrowState.CASH_ARROW.value);
  }
}
