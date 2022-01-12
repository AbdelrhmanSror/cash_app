import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:sqflite/sqflite.dart';

import 'models/ArchiveModel.dart';

class ParentArchiveDatabase extends AppDatabase {
  ParentArchiveDatabase();

  final List<ParentArchiveDatabaseListener> _listeners = [];

  void registerListener(ParentArchiveDatabaseListener listener) {
    _listeners.add(listener);
  }

  void _alertOnStart(List<ParentArchivedModel> model) {
    for (var listener in _listeners) {
      listener.onRetrieveDatabase(model);
    }
  }

  // Define a function that inserts models into the database
  @override
  Future<void> insert(List<CashBookModel> modelToInsert) async {
    final db = await init();
    //getting last parent archive models inserted in table.
    ParentArchivedModel parentArchivedModel = (await getLastParentModel());
    int newParentId = parentArchivedModel.id + 1;
    Batch batch = db.batch();
    batch.insert(
      parentArchiveTable,
      ParentArchivedModel(
              id: newParentId,
              startDate: modelToInsert[0].date,
              endDate: modelToInsert[modelToInsert.length - 1].date,
              balance: modelToInsert[0].getBalance())
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    batch.commit(noResult: true);
  }

  // A method that retrieves latest model from the  table based on condition.
  Future<ParentArchivedModel> getLastParentModel() async {
    final db = await init();
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$parentArchiveTable"  ORDER BY "id" DESC LIMIT 1', []);

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<ParentArchivedModel> models = maps.toParentArchiveModels();
    //in case if the database is empty
    if (models.isEmpty) {
      return ParentArchivedModel();
    }
    return models[0];
  }

  // A method that retrieves latest model from the  table based on condition.
  Future<List<ParentArchivedModel>> _getParentArchiveModels() async {
    final db = await init();
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$parentArchiveTable"  ORDER BY "id" DESC ', []);

    print(maps);
    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<ParentArchivedModel> models = maps.toParentArchiveModels();
    //in case if the database is empty
    return models;
  }

  // A method that retrieves all the models from the  table.
  @override
  Future<void> retrieveAll({int parentId = -1}) async {
    print('retrieve all $parentId');
    _alertOnStart(await _getParentArchiveModels());
  }
}
