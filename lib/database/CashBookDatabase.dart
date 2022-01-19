import 'dart:async';

import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/dataClasses/Cash.dart';
import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/utility/dataClasses/Date.dart';
import 'package:sqflite/sqflite.dart';

import 'models/CashBookModel.dart';

class CashBookDatabase extends AppDatabase {
  // Define a function that inserts models into the database

  Future<void> insert(CashBookModel modelToInsert) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    final db = await init();
    Batch batch = db.batch();
    //getting the last row in table because newly inserted value depends on its cashIn Out values
    final CashBookModel lastModelInTable = await _getModel('', []);
    updateTotalCashInOut(modelToInsert, lastModelInTable);
    //we increment the id of newly inserted value by 1  based on last model in table.
    modelToInsert.id = lastModelInTable.id + 1;
    batch.insert(
      _tableName,
      modelToInsert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await batch.commit(noResult: true);
  }

  final String _tableName = cashBookTable;

  //retrieve all models in ascending order by id
  Future<CashBookModelListDetails> getAllWithID({List<int>? listOfIds}) async {
    // Query the table for all The model.
    final db = await init();
    double totalCashIn = 0;
    double totalCashOut = 0;
    String startDate = '';
    String endDate = '';
    final List<Map<String, dynamic>> maps;
    if (listOfIds == null) {
      maps =
          await db.rawQuery('SELECT * FROM "$_tableName"  ORDER BY "id" ASC ');
    } else {
      maps = await db.rawQuery(
          'SELECT * FROM "$_tableName"  WHERE "id" IN (${List.filled(listOfIds.length, '?').join(',')}) ORDER BY "id" ASC ',
          listOfIds);
    }
    final models = maps.toCashBookModels();
    if (models.isNotEmpty) {
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
    }

    //by default we return operation in descending order.
    return CashBookModelListDetails(models,
        totalCashIn: totalCashIn,
        totalCashOut: totalCashOut,
        startDate: startDate,
        endDate: endDate);
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
    if (modelsAfterModel.isNotEmpty) {
      updateTotalCashInOut(modelsAfterModel[0], firstModel);
      for (int i = 1; i < modelsAfterModel.length; i++) {
        updateTotalCashInOut(modelsAfterModel[i], modelsAfterModel[i - 1]);
      }
    }
    return modelsAfterModel;
  }

  Future<void> updateModel(CashBookModel model) async {
    var oldModel = await _getModel('id=?', [model.id]);
    var lastModel = await _getModel('', []);
    var lastModelBeforeUpdatedModel = await _getModel('id<?', [model.id]);

    //if the cash number has been changed ,then we update the total cash in and out before updating the database
    if (oldModel.cash != model.cash) {
      updateTotalCashInOut(model, lastModelBeforeUpdatedModel);
    }
    await _update(model);
    //if the change happened in cash column and because cash column affect other's row,
    // so we propagate the change to other's row that is after it
    List<CashBookModel> modelsAfterUpdatedModel =
        await _propagateUpdate(model, lastModel);
    await _updateAll(modelsAfterUpdatedModel);
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
    List<CashBookModel> modelsAfterDeletedModel =
        await _propagateUpdate(lastModelBeforeDeletedModel, lastModel);
    await _updateAll(modelsAfterDeletedModel);
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

  // A method that retrieves latest model from the  table based on condition.
  Future<CashBookModel?> getById(int id) async {
    final db = await init();
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_tableName"  WHERE id =? ORDER BY "id" DESC LIMIT 1',
        [id]);

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<CashBookModel> models = maps.toCashBookModels();
    //in case if the database is empty
    if (models.isEmpty) {
      return null;
    }
    return models[0];
  }

  Future<CashBookModelListDetails> retrieveAll(
      {Date? date,
      TypeFilter? type,
      CashRange? cashRange,
      SortFilter? sortFilter}) async {
    final db = await init();
    final argumentList = [];
    String whereClause = 'Where';
    double totalCashIn = 0;
    double totalCashOut = 0;
    String startDate = '';
    String endDate = '';
    if (date != null) {
      whereClause += ' date(date) BETWEEN ? And ?';
      argumentList.add(date.firstDate);
      argumentList.add(date.lastDate);
    }
    if (type != null &&
        (type == TypeFilter.CASH_IN || type == TypeFilter.CASH_OUT)) {
      if (whereClause.length == 5) {
        whereClause += ' type=?';
      } else {
        whereClause += ' And type=?';
      }
      argumentList.add(type.value);
    }
    if (cashRange != null) {
      if (whereClause.length == 5) {
        whereClause += ' cash>=? And cash <=?';
      } else {
        whereClause += ' And cash>=? And cash <=?';
      }
      argumentList.add(cashRange.first);
      argumentList.add(cashRange.last);
    }

    if (whereClause.length == 5) whereClause = '';
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_tableName" $whereClause ORDER BY "id" ASC ',
        argumentList);
    List<CashBookModel> modelsAfterModel = maps.toCashBookModels();
    //we propagate data based on the new fetched operations
    if (modelsAfterModel.isNotEmpty) {
      //delete the cash in and out date from first fetched model because it depends on operation in different  range
      updateTotalCashInOut(modelsAfterModel[0], EmptyCashBookModel());

      if (modelsAfterModel.length > 1) {
        for (int i = 1; i < modelsAfterModel.length; i++) {
          updateTotalCashInOut(modelsAfterModel[i], modelsAfterModel[i - 1]);
        }
      }
      totalCashIn = modelsAfterModel[modelsAfterModel.length - 1].totalCashIn;
      totalCashOut = modelsAfterModel[modelsAfterModel.length - 1].totalCashOut;
      startDate = modelsAfterModel[0].date;
      endDate = modelsAfterModel[modelsAfterModel.length - 1].date;
    }

    if (sortFilter == SortFilter.OLDER) {
      return CashBookModelListDetails(modelsAfterModel,
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    }

    if (sortFilter == SortFilter.CASH_HIGH_TO_LOW) {
      return CashBookModelListDetails(
          modelsAfterModel..sort((a, b) => -1 * a.cash.compareTo(b.cash)),
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    }
    if (sortFilter == SortFilter.CASH_LOW_TO_HIGH) {
      return CashBookModelListDetails(
          modelsAfterModel..sort((a, b) => a.cash.compareTo(b.cash)),
          totalCashIn: totalCashIn,
          totalCashOut: totalCashOut,
          startDate: startDate,
          endDate: endDate);
    }
    print('filtered modles $modelsAfterModel \n\n\n');

    //by default we return operation in descending order.
    return CashBookModelListDetails(modelsAfterModel.reversed.toList(),
        totalCashIn: totalCashIn,
        totalCashOut: totalCashOut,
        startDate: startDate,
        endDate: endDate);
  }

  Future<void> deleteAll(List<CashBookModel> models) async {
    final db = await init();
    Batch batch = db.batch();
    for (var model in models) {
      batch.delete(_tableName, where: 'id = ?', whereArgs: [model.id]);
    }
    await batch.commit(noResult: true);
  }
}
