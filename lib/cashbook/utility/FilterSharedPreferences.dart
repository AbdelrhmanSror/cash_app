import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';
import 'dataClasses/Cash.dart';
import 'dataClasses/Date.dart';

class FilterSharedPreferences {
  static Future<void> _setFilterState(
      SharedPreferences prefs, bool cleared) async {
    await prefs.setBool(FILTER_STATE, cleared);
  }

  static Future<bool> getFilterState() async {
    final prefs = await SharedPreferences.getInstance();
    final state = (prefs.getBool(FILTER_STATE)) ?? true;
    return state;
  }

  static Future<void> setDateTypeInPreferences(DateFilter dateFilter) async {
    final prefs = await SharedPreferences.getInstance();
    _setFilterState(prefs, false);
    await prefs.setString(DATE, dateFilter.value);
  }

  static Future<DateFilter> getDateTypeFromPreferences(
      {DateFilter defaultValue = DateFilter.all}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dateFilter = prefs.getString(DATE);
    if (dateFilter == null) return defaultValue;
    return dateFilter.dateFilter;
  }

  static Future<void> setTypesInPreferences(TypeFilter typeFilter) async {
    final prefs = await SharedPreferences.getInstance();
    _setFilterState(prefs, false);
    prefs.setString(TYPE, typeFilter.value);
  }

  static Future<TypeFilter> getTypesFromPreferences(
      {TypeFilter defaultValue = TypeFilter.all}) async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString(TYPE);
    if (type == null) return defaultValue;
    return type.typeFilter;
  }

  static Future<void> setSortInPreferences(SortFilter sortFilter) async {
    final prefs = await SharedPreferences.getInstance();
    _setFilterState(prefs, false);
    if (sortFilter.value == SortFilter.latest.value) {
      prefs.setString(SORT, SortFilter.latest.value);
    } else if (sortFilter.value == SortFilter.older.value) {
      prefs.setString(SORT, SortFilter.older.value);
    } else if (sortFilter.value == SortFilter.cashHighToLow.value) {
      prefs.setString(SORT, SortFilter.cashHighToLow.value);
    } else if (sortFilter.value == SortFilter.cashLowToHigh.value) {
      prefs.setString(SORT, SortFilter.cashLowToHigh.value);
    }
  }

  static Future<SortFilter> getSortFromPreferences(
      {SortFilter defaultValue = SortFilter.latest}) async {
    final prefs = await SharedPreferences.getInstance();
    final sort = prefs.getString(SORT);
    if (sort == SortFilter.older.value) {
      return SortFilter.older;
    }
    if (sort == SortFilter.cashHighToLow.value) {
      return SortFilter.cashHighToLow;
    }
    if (sort == SortFilter.cashLowToHigh.value) {
      return SortFilter.cashLowToHigh;
    }
    //by default data is sorted in descending order.
    return defaultValue;
  }

  static Future<void> setDateInPreferences(Date date) async {
    final prefs = await SharedPreferences.getInstance();
    _setFilterState(prefs, false);
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

  static Future<void> setCashRangeInPreferences(SharedPreferences prefs, CashRange cashRange) async {
    final prefs = await SharedPreferences.getInstance();
    _setFilterState(prefs, false);
    prefs.setDouble(CASH_START_RANGE, cashRange.first);
    prefs.setDouble(CASH_END_RANGE, cashRange.last);
  }

  static Future<CashRange> getCashRangeFromPreferences(CashRange defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    final startCash = prefs.getDouble(CASH_START_RANGE) ?? defaultValue.first;
    final endCash = prefs.getDouble(CASH_END_RANGE) ?? defaultValue.last;
    return CashRange(startCash, endCash);
  }

  static Future<void> flipArrowState(FilterArrowState filterArrowState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final previousState = await getArrowState(preferences, filterArrowState);
    preferences.setBool(filterArrowState.value, !previousState);
  }

  static Future<bool> getArrowState(
      SharedPreferences prefs, FilterArrowState filterArrowState) async {
    return prefs.getBool(filterArrowState.value) ?? true;
  }

  static Future<void> clearFilter() async {
    //clear all data in preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _setFilterState(preferences, true);
    preferences.remove(SORT);
    preferences.remove(TYPE);
    preferences.remove(CASH_START_RANGE);
    preferences.remove(CASH_END_RANGE);
    preferences.remove(DATE_START_RANGE);
    preferences.remove(DATE_END_RANGE);
    preferences.remove(DATE);
    preferences.remove(FilterArrowState.sortArrow.value);
    preferences.remove(FilterArrowState.dateArrow.value);
    preferences.remove(FilterArrowState.typeArrow.value);
    preferences.remove(FilterArrowState.cashArrow.value);
  }
}
