import 'package:debts_app/database/models/CashBookModel.dart';

class ParentArchivedModel {
  final int id;
  String startDate;
  String endDate;
  double balance;

  ParentArchivedModel(
      {this.id = -1, this.startDate = '', this.endDate = '', this.balance = 0});

  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return '$id';
  }
}

class ArchivedModel extends CashBookModel {
  int parentModelId;
  CashBookModel model;

  ArchivedModel({
    this.parentModelId = 0,
    required this.model,
  }) : super(
            id: model.id,
            date: model.date,
            description: model.description,
            totalCashIn: model.totalCashIn,
            totalCashOut: model.totalCashOut,
            cash: model.cash,
            type: model.type);

  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.

  @override
  Map<String, dynamic> toMap() {
    return {
      'parentModelId': parentModelId,
      'id': id,
      'date': date,
      'cash': cash,
      'totalCashIn': totalCashIn,
      'totalCashOut': totalCashOut,
      'description': description,
      'type': type
    };
  }

  @override
  String toString() {
    return 'AppModel{id: $id, date: $date, cash: $cash  cashout:$totalCashOut  cashin $totalCashIn  type $type}' +
        'parentalId:$parentModelId';
  }
}

extension ToParentArchiveModel on List<Map<String, dynamic>> {
  List<ParentArchivedModel> toParentArchiveModels() =>
      List.generate(length, (i) {
        return ParentArchivedModel(
            id: this[i]['id'],
            startDate: this[i]['startDate'],
            endDate: this[i]['endDate'],
            balance: this[i]['balance']);
      });
}

extension ToCashBookModel on List<ArchivedModel> {
  List<CashBookModel> toCashBookModels() => List.generate(length, (i) {
        return CashBookModel(
            id: this[i].id,
            date: this[i].date,
            totalCashIn: this[i].totalCashIn,
            totalCashOut: this[i].totalCashOut,
            cash: this[i].cash,
            description: this[i].description,
            type: this[i].type);
      });
}

extension ToArchiveModelList1 on List<Map<String, dynamic>> {
  List<ArchivedModel> toArchivedModels() => List.generate(length, (i) {
        return ArchivedModel(
            parentModelId: this[i]['parentModelId'],
            model: CashBookModel(
                id: this[i]['id'],
                date: this[i]['date'],
                totalCashIn: this[i]['totalCashIn'],
                totalCashOut: this[i]['totalCashOut'],
                cash: this[i]['cash'],
                description: this[i]['description'],
                type: this[i]['type']));
      });
}
