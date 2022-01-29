import 'dart:async';

import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:sqflite/sqflite.dart';

import 'AppDatabase.dart';
import 'models/ArchiveModel.dart';
import 'models/CashBookModel.dart';

class ArchiveDatabase extends AppDatabase {
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
        'SELECT * FROM "$childArchiveTable" WHERE parentModelId=$parentId ORDER BY "id" ASC');
    return maps.toArchivedModels();
  }

  // A method that retrieves all the models from the  table.
  Future<CashBookModelListDetails> retrieveAll(int parentId) async {
    double totalCashIn = 0;
    double totalCashOut = 0;
    String startDate = '';
    String endDate = '';
    final models = (await _getArchivedModels(parentId)).toCashBookModels();
    //delete the cash in and out date from first fetched model because it depends on operation in different  range
    updateTotalCashInOut(models[0], EmptyCashBookModel());
    if (models.length > 1) {
      for (int i = 1; i < models.length; i++) {
        updateTotalCashInOut(models[i], models[i - 1]);
      }
    }
    totalCashIn = models[models.length - 1].totalCashIn;
    totalCashOut = models[models.length - 1].totalCashOut;
    startDate = models[0].date;
    endDate = models[models.length - 1].date;

    return CashBookModelListDetails(models,
        totalCashIn: totalCashIn,
        totalCashOut: totalCashOut,
        startDate: startDate,
        endDate: endDate);
  }
}
