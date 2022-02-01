import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';
import 'dataClasses/Cash.dart';
import 'dataClasses/Date.dart';

class FilterSharedPreferences {
  static Future<void> setDateTypeInPreferences(DateFilter dateFilter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(DATE, dateFilter.value);
  }

  static Future<DateFilter> getDateTypeFromPreferences(
      {DateFilter defaultValue = DateFilter.ALL}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dateFilter = prefs.getString(DATE);
    if (dateFilter == null) return defaultValue;
    return dateFilter.dateFilter;
  }

  static Future<void> setTypesInPreferences(TypeFilter typeFilter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(TYPE, typeFilter.value);
  }

  static Future<TypeFilter> getTypesFromPreferences(
      {TypeFilter defaultValue = TypeFilter.ALL}) async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString(TYPE);
    if (type == null) return defaultValue;
    return type.typeFilter;
  }

  static Future<void> setSortInPreferences(SortFilter sortFilter) async {
    final prefs = await SharedPreferences.getInstance();
    if (sortFilter.value == SortFilter.LATEST.value) {
      prefs.setString(SORT, SortFilter.LATEST.value);
    } else if (sortFilter.value == SortFilter.OLDER.value) {
      prefs.setString(SORT, SortFilter.OLDER.value);
    } else if (sortFilter.value == SortFilter.CASH_HIGH_TO_LOW.value) {
      prefs.setString(SORT, SortFilter.CASH_HIGH_TO_LOW.value);
    } else if (sortFilter.value == SortFilter.CASH_LOW_TO_HIGH.value) {
      prefs.setString(SORT, SortFilter.CASH_LOW_TO_HIGH.value);
    }
  }

  static Future<SortFilter> getSortFromPreferences(
      {SortFilter defaultValue = SortFilter.LATEST}) async {
    final prefs = await SharedPreferences.getInstance();
    final sort = prefs.getString(SORT);
    if (sort == SortFilter.OLDER.value) {
      return SortFilter.OLDER;
    }
    if (sort == SortFilter.CASH_HIGH_TO_LOW.value) {
      return SortFilter.CASH_HIGH_TO_LOW;
    }
    if (sort == SortFilter.CASH_LOW_TO_HIGH.value) {
      return SortFilter.CASH_LOW_TO_HIGH;
    }
    //by default data is sorted in descending order.
    return defaultValue;
  }

  static Future<void> setDateInPreferences(Date date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DATE_START_RANGE, date.firstDate);
    prefs.setString(DATE_END_RANGE, date.lastDate);
  }

  static Future<Date> getDateFromPreferences(Date defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    final startDate =
        prefs.getString(DATE_START_RANGE) ?? defaultValue.firstDate;
    final endDate = prefs.getString(DATE_END_RANGE) ?? defaultValue.lastDate;
    return Date(startDate, endDate);
  }

  static Future<void> setCashRangeInPreferences(
      SharedPreferences prefs, CashRange cashRange) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(CASH_START_RANGE, cashRange.first);
    prefs.setDouble(CASH_END_RANGE, cashRange.last);
  }

  static Future<CashRange> getCashRangeFromPreferences(
      CashRange defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    final startCash = prefs.getDouble(CASH_START_RANGE) ?? defaultValue.first;
    final endCash = prefs.getDouble(CASH_END_RANGE) ?? defaultValue.last;
    return CashRange(startCash, endCash);
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
