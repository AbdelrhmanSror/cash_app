enum TypeFilter { CASH_IN, CASH_OUT, BOTH }

extension TypeExtension on TypeFilter {
  String get value {
    if (this == TypeFilter.CASH_IN) {
      return CASH_IN;
    } else if (this == TypeFilter.CASH_OUT) {
      return CASH_OUT;
    } else {
      return CASH_IN_OUT;
    }
  }
}

enum SortFilter { CASH_LOW_TO_HIGH, CASH_HIGH_TO_LOW, LATEST, OLDER }

const String CASH_IN = 'Cash In';
const String CASH_OUT = 'Cash Out';
const String CASH_IN_OUT = 'Cash in Out';
const String UPDATE = 'Update';
const String INSERT = 'Insert';
