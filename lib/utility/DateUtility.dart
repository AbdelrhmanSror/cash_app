import 'package:intl/intl.dart';

class Date {
  final String firstDate;
  final String lastDate;

  Date(this.firstDate, this.lastDate);
}

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

  static String getDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just now';
    }

    // DateFormat.jm()                  -> 5:08 PM
    String roughTimeString = DateFormat('jm').format(dateTime);
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today at $roughTimeString';
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday at ' + roughTimeString;
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return '$weekday at $roughTimeString';
    }
    return '${DateFormat('d MMMM y').format(dateTime)} at $roughTimeString';
  }
}
