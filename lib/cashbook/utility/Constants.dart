enum TypeFilter { CASH_IN, CASH_OUT, ALL }

extension TypeExtension on TypeFilter {
  String get value {
    if (this == TypeFilter.CASH_IN) {
      return _CASH_IN;
    } else if (this == TypeFilter.CASH_OUT) {
      return _CASH_OUT;
    } else {
      return 'ALL';
    }
  }
}

extension TypeExtensionString on String {
  TypeFilter get typeFilter {
    if (this == TypeFilter.CASH_IN.value) {
      return TypeFilter.CASH_IN;
    } else if (this == TypeFilter.CASH_OUT.value) {
      return TypeFilter.CASH_OUT;
    } else {
      return TypeFilter.ALL;
    }
  }
}

enum SortFilter { CASH_LOW_TO_HIGH, CASH_HIGH_TO_LOW, LATEST, OLDER }

extension SortExtension on SortFilter {
  String get value {
    if (this == SortFilter.LATEST) {
      return _LATEST;
    } else if (this == SortFilter.OLDER) {
      return _OLDER;
    } else if (this == SortFilter.CASH_LOW_TO_HIGH) {
      return _CASH_LOW_TO_HIGH;
    } else {
      return _CASH_HIGH_TO_LOW;
    }
  }
}

enum DateFilter {
  THIS_WEEK,
  LAST_7_DAYS,
  THIS_YEAR,
  LAST_30_DAYS,
  LAST_MONTH,
  ALL,
  CUSTOM
}

enum ArrowState { EXPANDED, UNEXPANDED }

extension ArrowStateExtension on ArrowState {
  bool get value {
    if (this == ArrowState.EXPANDED) {
      return true;
    } else {
      return false;
    }
  }
}

enum FilterArrowState {
//variable represents the state of filter options arrow
  DATE_ARROW,
  CASH_ARROW,
  SORT_ARROW,
  TYPE_ARROW
}

extension FilterArrowStateExtension on FilterArrowState {
  String get value {
    if (this == FilterArrowState.DATE_ARROW) {
      return DATE_ARROW;
    }
    if (this == FilterArrowState.CASH_ARROW) {
      return CASH_ARROW;
    }
    if (this == FilterArrowState.SORT_ARROW) {
      return SORT_ARROW;
    } else {
      return TYPE_ARROW;
    }
  }
}

extension DateTypeExtension on DateFilter {
  String get value {
    if (this == DateFilter.THIS_WEEK) {
      return _THIS_WEEK;
    }
    if (this == DateFilter.LAST_7_DAYS) {
      return _LAST_7_DAYS;
    }
    if (this == DateFilter.THIS_YEAR) {
      return _THIS_YEAR;
    }
    if (this == DateFilter.LAST_30_DAYS) {
      return _LAST_30_DAYS;
    }
    if (this == DateFilter.LAST_MONTH) {
      return _LAST_MONTH;
    } else if (this == DateFilter.CUSTOM) {
      return _CUSTOM;
    } else {
      return 'ALL';
    }
  }
}

extension TypeDateExtensionString on String {
  DateFilter get dateFilter {
    if (this == _THIS_WEEK) {
      return DateFilter.THIS_WEEK;
    }
    if (this == _LAST_7_DAYS) {
      return DateFilter.LAST_7_DAYS;
    }
    if (this == _THIS_YEAR) {
      return DateFilter.THIS_YEAR;
    }
    if (this == _LAST_30_DAYS) {
      return DateFilter.LAST_30_DAYS;
    }
    if (this == _LAST_MONTH) {
      return DateFilter.LAST_MONTH;
    } else if (this == _CUSTOM) {
      return DateFilter.CUSTOM;
    } else {
      return DateFilter.ALL;
    }
  }
}

enum OperationType { UPDATE, INSERT, DELETE }

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
const String DATE_ARROW = "date arrow ";
const String CASH_ARROW = 'cash arrow ';
const String SORT_ARROW = 'sort arrow ';
const String TYPE_ARROW = 'type arrow ';
