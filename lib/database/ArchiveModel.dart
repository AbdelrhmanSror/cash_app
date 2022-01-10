class ParentArchivedModel {
  int id;

  ParentArchivedModel({this.id = 0});

  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  @override
  String toString() {
    return '$id';
  }
}

class ArchivedModel {
  int parentModelId;
  int id;
  final String date;
  final double cash;
  double totalCashIn;
  double totalCashOut;
  final String description;
  final String type;

  ArchivedModel({
    this.id = 0,
    this.parentModelId = 0,
    required this.date,
    this.totalCashIn = 0,
    this.totalCashOut = 0,
    this.description = '',
    required this.cash,
    required this.type,
  });

  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.

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
        return ParentArchivedModel(id: this[i]['id']);
      });
}

extension ToArchiveModel on List<Map<String, dynamic>> {
  List<ArchivedModel> toArchivedModels() => List.generate(length, (i) {
        return ArchivedModel(
            parentModelId: this[i]['parentModelId'],
            id: this[i]['id'],
            date: this[i]['date'],
            totalCashIn: this[i]['totalCashIn'],
            totalCashOut: this[i]['totalCashOut'],
            cash: this[i]['cash'],
            description: this[i]['description'],
            type: this[i]['type']);
      });
}
