enum TypeFilter { CASH_IN, CASH_OUT }

extension TypeExtension on TypeFilter {
  String get value {
    if (this == TypeFilter.CASH_IN) {
      return CASH_IN;
    } else {
      return CASH_OUT;
    }
  }
}

extension TypeExtensionString on String {
  TypeFilter get typeFilter {
    if (this == TypeFilter.CASH_IN.value) {
      return TypeFilter.CASH_IN;
    } else {
      return TypeFilter.CASH_OUT;
    }
  }
}

enum SortFilter { CASH_LOW_TO_HIGH, CASH_HIGH_TO_LOW, LATEST, OLDER }

extension SortExtension on SortFilter {
  String get value {
    if (this == SortFilter.LATEST) {
      return LATEST;
    } else if (this == SortFilter.OLDER) {
      return OLDER;
    } else if (this == SortFilter.CASH_LOW_TO_HIGH) {
      return CASH_LOW_TO_HIGH;
    } else {
      return CASH_HIGH_TO_LOW;
    }
  }
}

enum DateFilter {
  THIS_WEEK,
  LAST_7_DAYS,
  THIS_YEAR,
  LAST_30_DAYS,
  LAST_MONTH,
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
      return THIS_WEEK;
    }
    if (this == DateFilter.LAST_7_DAYS) {
      return LAST_7_DAYS;
    }
    if (this == DateFilter.THIS_YEAR) {
      return THIS_YEAR;
    }
    if (this == DateFilter.LAST_30_DAYS) {
      return LAST_30_DAYS;
    }
    if (this == DateFilter.LAST_MONTH) {
      return LAST_MONTH;
    } else {
      return CUSTOM;
    }
  }
}

extension TypeDateExtensionString on String {
  DateFilter get dateFilter {
    if (this == THIS_WEEK) {
      return DateFilter.THIS_WEEK;
    }
    if (this == LAST_7_DAYS) {
      return DateFilter.LAST_7_DAYS;
    }
    if (this == THIS_YEAR) {
      return DateFilter.THIS_YEAR;
    }
    if (this == LAST_30_DAYS) {
      return DateFilter.LAST_30_DAYS;
    }
    if (this == LAST_MONTH) {
      return DateFilter.LAST_MONTH;
    } else {
      return DateFilter.CUSTOM;
    }
  }
}

enum OperationType { UPDATE, INSERT, DELETE }

const String CASH_IN = 'Cash In';
const String CASH_OUT = 'Cash Out';

const String CASH_LOW_TO_HIGH = 'Cash low To High';
const String CASH_HIGH_TO_LOW = 'Cash high To low';
const String LATEST = 'Latest';
const String OLDER = 'Older';

const String THIS_WEEK = 'THIS_WEEK';
const String LAST_7_DAYS = 'LAST_7_DAYS';
const String THIS_YEAR = 'THIS_YEAR';
const String LAST_30_DAYS = 'LAST_30_DAYS';
const String LAST_MONTH = 'LAST_MONTH';
const String CUSTOM = 'CUSTOM';

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
