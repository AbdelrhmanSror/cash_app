import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:sqflite/sqflite.dart';

import 'models/ArchiveModel.dart';

class ArchiveDatabase extends AppDatabase<ArchivedModel> {
  ArchiveDatabase();

  // Define a function that inserts models into the database
  @override
  Future<void> insert(List<CashBookModel> modelsToInsert,
      {int parentId = -1}) async {
    final db = await init();

    if (parentId == -1) {
      _insertWhenNotExist(db, modelsToInsert);
    } else {
      _insertWhenExist(db, modelsToInsert, parentId);
    }
    // alertOnInsertion(modelsToInsert);
  }

  void _insertWhenExist(
      Database db, List<CashBookModel> modelsToInsert, int parentId) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.

    //get archive models

    final newParentArchivedModel = ParentArchivedModel(id: (parentId));
    final archivedModelsToInsert = modelsToInsert.toArchivedModels();
    final archiveModels = (await _getArchivedModels(parentId));
    var lastArchiveModelId =
        archiveModels.isNotEmpty ? archiveModels[0].id : -1;
    lastArchiveModelId++;
    updateTotalCashInOut(archivedModelsToInsert[0],
        archiveModels.isEmpty ? EmptyCashBookModel() : archiveModels[0]);
    archivedModelsToInsert[0].parentModelId = newParentArchivedModel.id;
    archivedModelsToInsert[0].id = lastArchiveModelId;
    Batch batch = db.batch();
    batch.insert(
      tableName,
      archivedModelsToInsert[0].toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    lastArchiveModelId++;

    for (int i = 1; i < modelsToInsert.length; i++) {
      updateTotalCashInOut(
          archivedModelsToInsert[i], archivedModelsToInsert[i - 1]);
      archivedModelsToInsert[i].parentModelId = newParentArchivedModel.id;
      archivedModelsToInsert[i].id = lastArchiveModelId;
      batch.insert(
        tableName,
        archivedModelsToInsert[i].toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      lastArchiveModelId++;
    }
    await batch.commit(noResult: true);
    alertOnInsertion(archivedModelsToInsert);
  }

  void _insertWhenNotExist(
      Database db, List<CashBookModel> modelsToInsert) async {
    //getting last parent archive models inserted in table.
    ParentArchivedModel parentArchivedModels =
        (await _getLastParentModel('', []));

    //we increment the id of newly inserted value by 1  based on last model in table.
    int newParentId = parentArchivedModels.id + 1;
    Batch batch = db.batch();
    batch.insert(
      parentArchiveTable,
      ParentArchivedModel(id: newParentId).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var model in modelsToInsert.toArchivedModels()) {
      model.parentModelId = newParentId;
      batch.insert(
        tableName,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // A method that retrieves latest model from the  table based on condition.
  Future<ParentArchivedModel> _getLastParentModel(
      String whereCondition, List<Object> whereArguments) async {
    final db = await init();
    String whereClause = '';
    if (whereCondition.isNotEmpty) whereClause = 'WHERE $whereCondition';
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$parentArchiveTable"  $whereClause ORDER BY "id" DESC LIMIT 1',
        whereArguments);

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<ParentArchivedModel> models = maps.toParentArchiveModels();
    //in case if the database is empty
    if (models.isEmpty) {
      return ParentArchivedModel();
    }
    return models[0];
  }

  /* // A method that retrieves latest model from the  table based on condition.
  Future<Map<dynamic, List<Map<String, dynamic>>>> _getArchivedModelsGroupedBy(
      String column) async {
    final db = await init();
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM "$childArchiveTable"');
    var newMap = groupBy(maps, (Map obj) => obj[column]);

    return newMap;
  }*/

  Future<List<ArchivedModel>> _getArchivedModels(int parentId) async {
    // Query the table for all The model.
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$tableName" WHERE parentModelId=$parentId ORDER BY "id" DESC');
    return maps.toArchivedModels();
  }

  int? _getIndex(int id, List<ArchivedModel> models) {
    for (int index = 0; index < models.length; index++) {
      if (models[index].id == id) {
        return index;
      }
    }
    return null;
  }

  @override
  Future<ArchivedModel> updateModel(CashBookModel model,
      {int parentId = 0}) async {
    List<ArchivedModel> archivedModels =
        (await _getArchivedModels(parentId)).reversed.toList();
    var index = _getIndex(model.id, archivedModels);
    final newArchivedModel =
        ArchivedModel(model: model, parentModelId: parentId);

    ArchivedModel oldArchivedModel = archivedModels[index!];

    ArchivedModel lastArchivedModel = archivedModels[archivedModels.length - 1];

    CashBookModel lastModelBeforeUpdatedModel =
        lastModelBeforeModel(index, archivedModels);

    //if the cash number has been changed ,then we update the total cash in and out before updating the database
    if (oldArchivedModel.cash != newArchivedModel.cash) {
      updateTotalCashInOut(newArchivedModel, lastModelBeforeUpdatedModel);
    }

    //if the update model was the last model then just update it cause it won't affect other's model data.
    //if the change didn't happen in cash column just update the model
    if (lastArchivedModel.id == newArchivedModel.id ||
        oldArchivedModel.cash == newArchivedModel.cash) {
      await _update(newArchivedModel);
      alertOnUpdate(newArchivedModel);
      return newArchivedModel;
    }

    await _update(newArchivedModel);
    //if the change happened in cash column and because cash column affect other's row,
    // so we propagate the change to other's row that is after it
    List<ArchivedModel> modelsAfterUpdatedModel = await _propagateUpdate(
        newArchivedModel,
        archivedModels.sublist(index + 1, archivedModels.length));
    _updateAll(parentId, modelsAfterUpdatedModel);
    return newArchivedModel;
  }

  CashBookModel lastModelBeforeModel(
      int index, List<ArchivedModel> archivedModels) {
    var lastModelBeforeUpdatedModel = (index - 1) < 0
        ? EmptyCashBookModel()
        : archivedModels[index - 1].model;
    return lastModelBeforeUpdatedModel;
  }

  Future<List<ArchivedModel>> _propagateUpdate(
      CashBookModel newArchivedModel, List<ArchivedModel> models) async {
    updateTotalCashInOut(models[0], newArchivedModel);
    for (int i = 1; i < models.length; i++) {
      updateTotalCashInOut(models[i], models[i - 1]);
    }

    return models;
  }

// Define a function that inserts models into the database
  Future<void> _updateAll(int parentId, List<ArchivedModel> models) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    final db = await init();
    Batch batch = db.batch();
    for (int i = 0; i < models.length; i++) {
      batch.update(tableName, models[i].toMap(),
          where: 'id = ?  AND parentModelId = ? ',
          whereArgs: [models[i].id, models[i].parentModelId]);
    }
    await batch.commit(noResult: true);

    //retrieve the updated models from table
    alertOnUpdateAll((await _getArchivedModels(parentId)));
  }

  // A method that retrieves all the models from the  table.
  @override
  Future<void> retrieveAll({int parentId = 1}) async {
    alertOnStart(await _getArchivedModels(parentId));
  }

  Future<void> _update(ArchivedModel model) async {
    final db = await init();
    // Update the given model.
    await db.update(
      tableName,
      model.toMap(),
      // Ensure that the model has a matching id.
      where: 'id = ? And parentModelId = ?',
      // Pass the model's id as a whereArg to prevent SQL injection.
      whereArgs: [model.id, model.parentModelId],
    );
  }

  Future<int> _getCount(int parentId) async {
    //database connection
    final db = await init();
    final x = await db.rawQuery(
        'SELECT COUNT (*) from $tableName WHERE parentModelId = $parentId');
    var count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }

  @override
  Future<void> deleteModel(CashBookModel model, {int parentId = -1}) async {
    // Get a reference to the database.
    final db = await init();
    int count = await _getCount(parentId);

    //if we removed all the element on the table
    if (count <= 1) {
      deleteAll(parentId: parentId);
      return;
    }
    var archivedModels = (await _getArchivedModels(parentId)).reversed.toList();
    print('archivedModels  $archivedModels');
    var index = _getIndex(model.id, archivedModels);
    var lastArchivedModel = archivedModels[archivedModels.length - 1];

    var lastModelBeforeDeletedModel =
        lastModelBeforeModel(index!, archivedModels);
    // Remove the model from the database.
    await db.delete(
      tableName,
      // Use a `where` clause to delete a specific model.
      where: 'id = ? AND parentModelId = ? ',
      // Pass the Model's id as a whereArg to prevent SQL injection.
      whereArgs: [model.id, parentId],
    );

    //if the model deleted was the last model  so we do nothing as it won't affect any other model's data
    //otherwise it is going to affect other's data
    if (lastArchivedModel.id == model.id) {
      alertOnLastRowDeleted();
      return;
    } else {
      List<ArchivedModel> archivedModelsAfterDeletedModel =
          await _propagateUpdate(lastModelBeforeDeletedModel,
              archivedModels.sublist(index + 1, archivedModels.length));
      _updateAll(parentId, archivedModelsAfterDeletedModel);
    }
  }

  @override
  void deleteAll({int parentId = -1}) async {
    final db = await init();
    await db.delete(
      tableName,
      // Ensure that the model has a matching id.
      where: 'parentModelId = ?',
      // Pass the model's id as a whereArg to prevent SQL injection.
      whereArgs: [parentId],
    );
    alertOnDeleteAll([]);
  }

  @override
  String tableName = childArchiveTable;
}
