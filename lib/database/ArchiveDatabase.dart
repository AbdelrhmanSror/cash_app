import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:sqflite/sqflite.dart';

import 'models/ArchiveModel.dart';

class ArchiveDatabase extends AppDatabase {
  ArchiveDatabase();

  final List<ArchiveDatabaseListener> _listeners = [];

  void registerListener(ArchiveDatabaseListener listener) {
    _listeners.add(listener);
  }

  void _alertOnStart(List<CashBookModel> model) {
    for (var listener in _listeners) {
      listener.onRetrieveDatabase(model);
    }
  }

  // Define a function that inserts models into the database
  @override
  Future<void> insert(List<CashBookModel> modelToInsert) async {
    final db = await init();
    _insertWhenNoParentExist(db, modelToInsert);
  }

  void _insertWhenNoParentExist(
      Database db, List<CashBookModel> modelsToInsert) async {
    //getting last parent archive models inserted in table.
    ParentArchivedModel parentArchivedModel =
        (await parentArchiveDatabase.getLastParentModel());

    //we increment the id of newly inserted value by 1  based on last model in table.
    int newParentId = parentArchivedModel.id + 1;
    Batch batch = db.batch();
    parentArchiveDatabase.insert(modelsToInsert);
    for (var model in modelsToInsert.toArchivedModels()) {
      model.parentModelId = newParentId;
      batch.insert(
        childArchiveTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ArchivedModel>> _getArchivedModels(int parentId) async {
    // Query the table for all The model.
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$childArchiveTable" WHERE parentModelId=$parentId ORDER BY "id" DESC');
    return maps.toArchivedModels();
  }

  // A method that retrieves all the models from the  table.
  @override
  Future<void> retrieveAll({int parentId = -1}) async {
    print('retrieve all $parentId');
    _alertOnStart(await _getArchivedModels(parentId));
  }
}
