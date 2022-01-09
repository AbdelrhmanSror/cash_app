class EmptyAppModel extends AppModel {
  EmptyAppModel({date = '', cash = 0.0, type = ''})
      : super(date: date, cash: cash, type: type);
}

class AppModel {
  int id;
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
      'id': id,
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

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'AppModel{id: $id, date: $date, cash: $cash  cashout:$totalCashOut  cashin $totalCashIn  type $type}';
  }
}

extension ToAppModel on List<Map<String, dynamic>> {
  List<AppModel> toAppModels() => List.generate(length, (i) {
        return AppModel(
            id: this[i]['id'],
            date: this[i]['date'],
            totalCashIn: this[i]['totalCashIn'],
            totalCashOut: this[i]['totalCashOut'],
            cash: this[i]['cash'],
            description: this[i]['description'],
            type: this[i]['type']);
      });
}
