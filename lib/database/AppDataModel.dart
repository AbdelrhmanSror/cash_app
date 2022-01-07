class EmptyAppModel extends AppModel {
  EmptyAppModel(
      {date = '', cash = 0.0, totalCashIn = 0.0, totalCashOut = 0.0, type = ''})
      : super(
            date: date,
            cash: cash,
            totalCashOut: totalCashOut,
            totalCashIn: totalCashIn,
            type: type);
}

class AppModel {
  final int id;
  final String date;
  final double cash;
  double totalCashIn;
  double totalCashOut;
  final String description;
  final String type;

  AppModel(
      {this.id = 0,
      required this.date,
      this.totalCashIn = 0,
      this.totalCashOut = 0,
      this.description = '',
      required this.cash,
      required this.type});

  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'cash': cash,
      'totalCashIn': totalCashIn,
      'totalCashOut': totalCashOut,
      'description': description,
      'type': type
    };
  }

  double getBalance() {
    return totalCashIn - totalCashOut;
  }
}
