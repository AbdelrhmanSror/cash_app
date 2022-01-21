import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';
import 'package:sqflite/sqflite.dart';

import 'models/ArchiveModel.dart';

class ParentArchiveDatabase extends AppDatabase {
  ParentArchiveDatabase();

  // Define a function that inserts models into the database
  Future<int> createParentId(CashBookModelListDetails modelToInsert) async {
    final db = await init();
    //getting last parent archive models inserted in table.
    ParentArchivedModel parentArchivedModel = (await getLastParentModel());

    int newParentId = parentArchivedModel.id + 1;
    Batch batch = db.batch();
    batch.insert(
      parentArchiveTable,
      ParentArchivedModel(
              id: newParentId,
              startDate: modelToInsert.startDate,
              endDate: modelToInsert.endDate,
              balance: modelToInsert.getBalance())
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    batch.commit(noResult: true);
    return newParentId;
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

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<ParentArchivedModel> models = maps.toParentArchiveModels();
    //in case if the database is empty
    return models;
  }

  // A method that retrieves all the models from the  table.
  Future<List<ParentArchivedModel>> retrieveAll(int parentId) async {
    return await _getParentArchiveModels();
  }
}
