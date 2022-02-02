enum TypeFilter { cashIn, cashOut, all }

extension TypeExtension on TypeFilter {
  String get value {
    if (this == TypeFilter.cashIn) {
      return _CASH_IN;
    } else if (this == TypeFilter.cashOut) {
      return _CASH_OUT;
    } else {
      return 'ALL';
    }
  }
}

extension TypeExtensionString on String {
  TypeFilter get typeFilter {
    if (this == TypeFilter.cashIn.value) {
      return TypeFilter.cashIn;
    } else if (this == TypeFilter.cashOut.value) {
      return TypeFilter.cashOut;
    } else {
      return TypeFilter.all;
    }
  }
}

enum SortFilter { cashLowToHigh, cashHighToLow, latest, older }

extension SortExtension on SortFilter {
  String get value {
    if (this == SortFilter.latest) {
      return _LATEST;
    } else if (this == SortFilter.older) {
      return _OLDER;
    } else if (this == SortFilter.cashLowToHigh) {
      return _CASH_LOW_TO_HIGH;
    } else {
      return _CASH_HIGH_TO_LOW;
    }
  }
}

enum DateFilter {
  thisWeek,
  last7Days,
  thisYear,
  last30Days,
  lastMonth,
  all,
  custom
}

enum ArrowState { expanded, unExpanded }

extension ArrowStateExtension on ArrowState {
  bool get value {
    if (this == ArrowState.expanded) {
      return true;
    } else {
      return false;
    }
  }
}

enum FilterArrowState {
//variable represents the state of filter options arrow
  dateArrow,
  cashArrow,
  sortArrow,
  typeArrow
}

extension FilterArrowStateExtension on FilterArrowState {
  String get value {
    if (this == FilterArrowState.dateArrow) {
      return _DATE_ARROW;
    }
    if (this == FilterArrowState.cashArrow) {
      return _CASH_ARROW;
    }
    if (this == FilterArrowState.sortArrow) {
      return _SORT_ARROW;
    } else {
      return _TYPE_ARROW;
    }
  }
}

extension DateTypeExtension on DateFilter {
  String get value {
    if (this == DateFilter.thisWeek) {
      return _THIS_WEEK;
    }
    if (this == DateFilter.last7Days) {
      return _LAST_7_DAYS;
    }
    if (this == DateFilter.thisYear) {
      return _THIS_YEAR;
    }
    if (this == DateFilter.last30Days) {
      return _LAST_30_DAYS;
    }
    if (this == DateFilter.lastMonth) {
      return _LAST_MONTH;
    } else if (this == DateFilter.custom) {
      return _CUSTOM;
    } else {
      return 'ALL';
    }
  }
}

extension TypeDateExtensionString on String {
  DateFilter get dateFilter {
    if (this == _THIS_WEEK) {
      return DateFilter.thisWeek;
    }
    if (this == _LAST_7_DAYS) {
      return DateFilter.last7Days;
    }
    if (this == _THIS_YEAR) {
      return DateFilter.thisYear;
    }
    if (this == _LAST_30_DAYS) {
      return DateFilter.last30Days;
    }
    if (this == _LAST_MONTH) {
      return DateFilter.lastMonth;
    } else if (this == _CUSTOM) {
      return DateFilter.custom;
    } else {
      return DateFilter.all;
    }
  }
}

enum OperationType { update, insert, delete }

const String _CASH_IN = 'Cash In';
const String _CASH_OUT = 'Cash Out';

const String _CASH_LOW_TO_HIGH = 'Cash low To High';
const String _CASH_HIGH_TO_LOW = 'Cash high To low';
const String _LATEST = 'Latest';
const String _OLDER = 'Older';

const String _THIS_WEEK = 'THIS WEEK';
const String _LAST_7_DAYS = 'LAST 7 DAYS';
const String _THIS_YEAR = 'THIS YEAR';
const String _LAST_30_DAYS = 'LAST 30 DAYS';
const String _LAST_MONTH = 'LAST MONTH';
const String _CUSTOM = 'CUSTOM';

const String SORT = 'Sort type';
const String TYPE = 'operation Type';
const String DATE = 'Date Type Selection';

const String CASH_START_RANGE = 'start cash range';
const String CASH_END_RANGE = 'end cash range';
const String DATE_START_RANGE = 'start date range';
const String DATE_END_RANGE = 'end date range';

//variable represents the state of filter options arrow
const String _DATE_ARROW = "date arrow ";
const String _CASH_ARROW = 'cash arrow ';
const String _SORT_ARROW = 'sort arrow ';
const String _TYPE_ARROW = 'type arrow ';

const String FILTER_STATE = "filter state ";
