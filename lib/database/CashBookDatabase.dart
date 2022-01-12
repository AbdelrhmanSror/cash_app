import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:sqflite/sqflite.dart';

import 'models/CashBookModel.dart';

class CashBookDatabase extends AppDatabase {
  // Define a function that inserts models into the database
  final List<CashBookDatabaseListener> _listeners = [];

  void registerListener(CashBookDatabaseListener listener) {
    _listeners.add(listener);
    print('update $listener');
  }

  void _alertOnInsertion(List<CashBookModel> model) {
    for (var listener in _listeners) {
      listener.onInsertDatabase(model);
    }
  }

  void _alertOnDeleteAll(List<CashBookModel> models) {
    for (var listener in _listeners) {
      listener.onDeleteAllDatabase(models);
    }
  }

  void _alertOnLastRowDeleted() {
    for (var listener in _listeners) {
      listener.onLastRowDeleted();
    }
  }

  void _alertOnUpdateAll(List<CashBookModel> models) {
    for (var listener in _listeners) {
      listener.onUpdateAllDatabase(models);
    }
  }

  void _alertOnUpdate(CashBookModel model) {
    for (var listener in _listeners) {
      listener.onUpdateDatabase(model);
    }
  }

  void _alertOnStart(List<CashBookModel> model) {
    for (var listener in _listeners) {
      listener.onRetrieveDatabase(model);
    }
  }

  @override
  Future<void> insert(List<CashBookModel> modelToInsert) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    final db = await init();
    Batch batch = db.batch();
    //getting the last row in table because newly inserted value depends on its cashIn Out values
    final CashBookModel lastModelInTable = await _getModel('', []);
    updateTotalCashInOut(modelToInsert[0], lastModelInTable);
    print('last model in table is $lastModelInTable\n');
    //we increment the id of newly inserted value by 1  based on last model in table.
    modelToInsert[0].id = lastModelInTable.id + 1;
    batch.insert(
      _tableName,
      modelToInsert[0].toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (int i = 1; i < modelToInsert.length; i++) {
      updateTotalCashInOut(modelToInsert[i], modelToInsert[i - 1]);
      modelToInsert[i].id = modelToInsert[i - 1].id + 1;
      batch.insert(
        _tableName,
        modelToInsert[i].toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    _alertOnInsertion(modelToInsert);
  }

  final String _tableName = cashBookTable;

  @override
  Future<void> retrieveAll({int parentId = -1}) async {
    // Query the table for all The model.
    final db = await init();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM "$_tableName" ORDER BY "id" DESC');
    _alertOnStart(maps.toCashBookModels());
  }

  // A method that retrieves  model from the  table based on range.
  //first excluding
  //last including
  Future<List<CashBookModel>> _getModelsInRange(int first, int last) async {
    final db = await init();
    // Query the table for all The model.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_tableName" WHERE "id" >  $first AND "id" <= $last ');

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<CashBookModel> models = maps.toCashBookModels();
    return models;
  }

  Future<List<CashBookModel>> _propagateUpdate(
      CashBookModel firstModel, CashBookModel lastModel) async {
    var modelsAfterModel = await _getModelsInRange(firstModel.id, lastModel.id);
    updateTotalCashInOut(modelsAfterModel[0], firstModel);
    for (int i = 1; i < modelsAfterModel.length; i++) {
      updateTotalCashInOut(modelsAfterModel[i], modelsAfterModel[i - 1]);
    }
    return modelsAfterModel;
  }

// A method that retrieves all the models from the  table.
  Future<List<CashBookModel>> _retrieveAll() async {
    // Query the table for all The model.
    final db = await init();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM "$_tableName" ORDER BY "id" DESC');
    return maps.toCashBookModels();
  }

  Future<CashBookModel> updateModel(CashBookModel model) async {
    var oldModel = await _getModel('id=?', [model.id]);
    var lastModel = await _getModel('', []);
    var lastModelBeforeUpdatedModel = await _getModel('id<?', [model.id]);

    //if the cash number has been changed ,then we update the total cash in and out before updating the database
    if (oldModel.cash != model.cash) {
      updateTotalCashInOut(model, lastModelBeforeUpdatedModel);
    }
    //if the update model was the last model then just update it cause it won't affect other's model data.
    //if the change didn't happen in cash column just update the model
    if (lastModel.id == model.id || oldModel.cash == model.cash) {
      // Update the given model.
      await _update(model);
      _alertOnUpdate(model);
      return model;
    }
    await _update(model);
    //if the change happened in cash column and because cash column affect other's row,
    // so we propagate the change to other's row that is after it
    List<CashBookModel> modelsAfterUpdatedModel =
        await _propagateUpdate(model, lastModel);
    _updateAll(modelsAfterUpdatedModel);
    return model;
  }

// Define a function that inserts models into the database
  Future<void> _updateAll(List<CashBookModel> model) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    final db = await init();
    Batch batch = db.batch();
    for (int i = 0; i < model.length; i++) {
      batch.update(_tableName, model[i].toMap(),
          where: 'id = ?', whereArgs: ['${model[i].id}']);
    }
    await batch.commit(noResult: true);

    //retrieve the updated models from table
    var updatedModels = await _retrieveAll();
    List<CashBookModel> models = updatedModels;
    _alertOnUpdateAll(models);
  }

  Future<void> _update(CashBookModel model) async {
    final db = await init();
    // Update the given model.
    await db.update(
      _tableName,
      model.toMap(),
      // Ensure that the model has a matching id.
      where: 'id = ?',
      // Pass the model's id as a whereArg to prevent SQL injection.
      whereArgs: [model.id],
    );
  }

  Future<void> deleteModel(CashBookModel model) async {
    // Get a reference to the database.
    final db = await init();
    var lastModelBeforeDeletedModel = await _getModel('id<?', [model.id]);
    var lastModel = await _getModel('', []);

    // Remove the model from the database.
    await db.delete(
      _tableName,
      // Use a `where` clause to delete a specific model.
      where: 'id = ?',
      // Pass the Model's id as a whereArg to prevent SQL injection.
      whereArgs: [model.id],
    );

    //if the model deleted was the last model  so we do nothing as it won't affect any other model's data
    //otherwise it is going to affect other's data
    if (lastModel.id == model.id) {
      _alertOnLastRowDeleted();
      return;
    } else {
      List<CashBookModel> modelsAfterDeletedModel =
          await _propagateUpdate(lastModelBeforeDeletedModel, lastModel);
      _updateAll(modelsAfterDeletedModel);
    }
  }

  // A method that retrieves latest model from the  table based on condition.
  Future<CashBookModel> _getModel(
      String whereCondition, List<Object> whereArguments) async {
    final db = await init();
    String whereClause = '';
    if (whereCondition.isNotEmpty) whereClause = 'WHERE $whereCondition';
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_tableName"  $whereClause ORDER BY "id" DESC LIMIT 1',
        whereArguments);

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<CashBookModel> models = maps.toCashBookModels();
    //in case if the database is empty
    if (models.isEmpty) {
      return EmptyCashBookModel();
    }
    return models[0];
  }

  /*Future<int> _getCount() async {
    //database connection
    final db = await init();
    final x = await db.rawQuery('SELECT COUNT (*) from $cashBookTable');
    var count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }*/

  void deleteAll() async {
    final db = await init();
    await db.delete(
      _tableName,
    );
    _alertOnDeleteAll([]);
  }
}
