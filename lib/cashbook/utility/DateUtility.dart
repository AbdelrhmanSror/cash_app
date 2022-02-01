import 'package:intl/intl.dart';

import 'dataClasses/Date.dart';

class DateUtility {
  static String removeTimeFromDate(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = DateTime.parse(dateTime.toString());
    final String formatted = dateFormat.format(displayDate);
    return formatted;
  }

  static Date getFirstAndLastDateInLastMonth() {
    final currentDate = DateTime.now();
    var firstDateInPreviousMonth =
        DateTime(currentDate.year, currentDate.month - 1, 1);
    //Providing a day value of zero for the next month gives you the previous month's last day
    var lastDayInPreviousMonth =
        DateTime(currentDate.year, currentDate.month, 0).day;
    var lastDateInPreviousMonth = DateTime(
        currentDate.year, currentDate.month - 1, lastDayInPreviousMonth);
    return Date(removeTimeFromDate(firstDateInPreviousMonth),
        removeTimeFromDate(lastDateInPreviousMonth));
  }

  static Date getFirstAndLastDateInLast30Days() {
    final currentDate = DateTime.now();
    DateTime firstDateBefore30Days =
        currentDate.subtract(const Duration(days: 30));
    return Date(removeTimeFromDate(firstDateBefore30Days),
        removeTimeFromDate(currentDate));
  }

  static Date getFirstAndLastDateInCurrentYear() {
    final currentDate = DateTime.now();
    DateTime firstDateInCurrentYear = DateTime(currentDate.year, 01, 01);
    return Date(removeTimeFromDate(firstDateInCurrentYear),
        removeTimeFromDate(currentDate));
  }

  static Date getFirstAndLastDateInLast7Days() {
    final currentDate = DateTime.now();
    DateTime firstDateBefore7Days =
        currentDate.subtract(const Duration(days: 7));
    return Date(removeTimeFromDate(firstDateBefore7Days),
        removeTimeFromDate(currentDate));
  }

  static Date getFirstAndLastDateInCurrentWeek() {
    final currentDate = DateTime.now();
    final firstDateInWeek = removeTimeFromDate(
        currentDate.subtract(Duration(days: (currentDate.weekday - 6) % 7)));
    final lastDateInWeek = removeTimeFromDate(currentDate);
    return Date(firstDateInWeek, lastDateInWeek);
  }

  static String getTimeRepresentation(DateTime dateTime) {
    return DateFormat('jm').format(dateTime);
  }

  static String getDateRepresentation(DateTime dateTime) {

    return DateFormat('d MMMM y').format(dateTime);
  }

  static String getAlphabeticDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = date.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just now';
    }

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today';
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return weekday;
    }
    return DateFormat('dd MMMM y').format(date);
  }

  static String getDateRepresentation2(DateTime dateTime) {
    return DateFormat('d/MM/y').format(dateTime);
  }
}
