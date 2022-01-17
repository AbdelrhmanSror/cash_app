import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:sqflite/sqflite.dart';

import 'models/ArchiveModel.dart';

class ArchiveDatabase extends AppDatabase<ArchivedModel> {
  ArchiveDatabase();

  // Define a function that inserts models into the database
  Future<void> insert(List<CashBookModel> modelsToInsert, int parentId) async {
    final db = await init();
    //getting last parent archive models inserted in table.

    //we increment the id of newly inserted value by 1  based on last model in table.
    Batch batch = db.batch();
    for (var model in modelsToInsert.toArchivedModels()) {
      model.parentModelId = parentId;
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
  Future<List<ArchivedModel>> retrieveAll(int parentId) async {
    final archivedModels = await _getArchivedModels(parentId);
    return archivedModels;
  }
}
