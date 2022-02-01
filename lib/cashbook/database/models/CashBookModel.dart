import 'ArchiveModel.dart';

class EmptyCashBookModel extends CashBookModel {
  EmptyCashBookModel() : super(date: '', cash: 0.0, type: '');
}

class CashBookModel {
  int id;
  final String date;
  final double cash;
  double totalCashIn;
  double totalCashOut;
  final String description;
  final String type;
  int groupId;

  CashBookModel(
      {this.id = -1,
      required this.date,
      this.totalCashIn = 0,
      this.totalCashOut = 0,
      this.description = '',
      required this.cash,
      required this.type,
      this.groupId = 0});

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
    return totalCashIn + totalCashOut;
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'AppModel{id: $id, groupId:$groupId ,date: $date, cash: $cash  cashout:$totalCashOut  cashin $totalCashIn  type $type}\n';
  }
}

extension ToCashBookModel on List<Map<String, dynamic>> {
  List<CashBookModel> toCashBookModels() => List.generate(length, (i) {
        return CashBookModel(
            id: this[i]['id'],
            date: this[i]['date'],
            totalCashIn: this[i]['totalCashIn'],
            totalCashOut: this[i]['totalCashOut'],
            cash: this[i]['cash'],
            description: this[i]['description'],
            type: this[i]['type']);
      });
}

extension ToArchiveModelList2 on List<CashBookModel> {
  List<ArchivedModel> toArchivedModels() => List.generate(length, (i) {
        return ArchivedModel(
            parentModelId: 0,
            model: CashBookModel(
                id: this[i].id,
                date: this[i].date,
                totalCashIn: this[i].totalCashIn,
                totalCashOut: this[i].totalCashOut,
                cash: this[i].cash,
                description: this[i].description,
                type: this[i].type));
      });
}
