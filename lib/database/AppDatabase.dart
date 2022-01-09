import 'dart:async';

import 'package:debts_app/utility/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'AppDataModel.dart';
import 'AppDatabaseCallback.dart';

class AppDatabase {
  final String _tableName = 'appModel';
  final List<AppDatabaseListener> _listeners = [];
  Future<Database>? _database;

  AppDatabase() {}

  void registerListener(AppDatabaseListener listener) {
    _listeners.add(listener);
  }

  void _alertOnInsertion(AppModel models) {
    for (var listener in _listeners) {
      listener.onInsertDatabase(models);
    }
  }

  void _alertOnStart(List<AppModel> models) {
    for (var listener in _listeners) {
      listener.onStartDatabase(models);
    }
  }

  void _alertOnDeleteAll(EmptyAppModel model) {
    for (var listener in _listeners) {
      listener.onDeleteAllDatabase(model);
    }
  }

  void _alertOnLastRowDeleted() {
    for (var listener in _listeners) {
      listener.onLastRowDeleted();
    }
  }

  void _alertOnUpdateAll(List<AppModel> models) {
    for (var listener in _listeners) {
      listener.onUpdateAllDatabase(models);
    }
  }

  void _alertOnUpdate(AppModel model) {
    for (var listener in _listeners) {
      listener.onUpdateDatabase(model);
    }
  }

  Future<Database> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'app_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY  NOT NULL, date TEXT, totalCashIn DOUBLE,totalCashOut DOUBLE,cash DOUBLE,type TEXT,description TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  void _updateTotalCashInOut(AppModel currentModel, AppModel previousModel) {
    if (currentModel.type == CASH_IN) {
      currentModel.totalCashIn = previousModel.totalCashIn + currentModel.cash;
      currentModel.totalCashOut = previousModel.totalCashOut;
    } else {
      currentModel.totalCashOut =
          previousModel.totalCashOut + currentModel.cash;
      currentModel.totalCashIn = previousModel.totalCashIn;
    }
  }

  // Define a function that inserts models into the database
  Future<void> insert(AppModel model) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    _database = _database ?? _init();
    final db = await _database!;

    //getting the last row in table because newly inserted value depends on its cashIn Out values
    final AppModel lastModelInTable = await _getModel('', []);
    _updateTotalCashInOut(model, lastModelInTable);
    //we increment the id of newly inserted value by 1  based on last model in table.
    model.id = lastModelInTable.id + 1;
    await db.insert(
      _tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _alertOnInsertion(model);
  }

  // Define a function that inserts models into the database
  Future<Object?> _updateAll(List<AppModel> model) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    _database = _database ?? _init();
    final db = await _database!;
    Batch batch = db.batch();
    for (int i = 0; i < model.length; i++) {
      batch.update(_tableName, model[i].toMap(),
          where: 'id = ?', whereArgs: ['${model[i].id}']);
    }
    await batch.commit(noResult: true);

    //retrieve the updated models from table
    var updatedModels = await _retrieveAll();
    _alertOnUpdateAll(updatedModels);
  }

  // A method that retrieves  model from the  table based on range.
  //first excluding
  //last including
  Future<List<AppModel>> _getModelsInRange(int first, int last) async {
    _database = _database ?? _init();
    final db = await _database!;

    // Query the table for all The model.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_tableName" WHERE "id" >  $first AND "id" <= $last ');

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<AppModel> models = maps.toAppModels();
    return models;
  }

  // A method that retrieves latest model from the  table.
  Future<AppModel> _getModel(
      String whereCondition, List<Object> whereArguments) async {
    _database = _database ?? _init();
    final db = await _database!;
    String whereClause = '';
    if (whereCondition.isNotEmpty) whereClause = 'WHERE $whereCondition';
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_tableName"  $whereClause ORDER BY "id" DESC LIMIT 1',
        whereArguments);

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<AppModel> models = maps.toAppModels();
    //in case if the database is empty
    if (models.isEmpty) {
      return EmptyAppModel();
    }
    return models[0];
  }

// A method that retrieves all the models from the  table.
  Future<List<AppModel>> _retrieveAll() async {
    // Query the table for all The model.
    _database = _database ?? _init();
    final db = await _database!;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM "$_tableName" ORDER BY "id" DESC');

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<AppModel> models = maps.toAppModels();
    if (models.isEmpty) {
      models.add(EmptyAppModel());
    }
    return models;
  }

// A method that retrieves all the models from the  table and alert the listeners.
  void retrieveAll() async {
    _alertOnStart(await _retrieveAll());
  }

  Future<AppModel> updateModel(AppModel model) async {
    // Get a reference to the database.
    var oldModel = await _getModel('id=?', [model.id]);
    var lastModel = await _getModel('', []);
    var lastModelBeforeUpdatedModel = await _getModel('id<?', [model.id]);

    //if the cash number has been changed ,then we update the total cash in and out before updating the database
    if (oldModel.cash != model.cash) {
      _updateTotalCashInOut(model, lastModelBeforeUpdatedModel);
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
    List<AppModel> modelsAfterUpdatedModel =
        await _propagateUpdate(model, lastModel);
    _updateAll(modelsAfterUpdatedModel);
    return model;
  }

  Future<void> _update(AppModel model) async {
    final db = await (_database ?? _init());
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

  Future<void> deleteModel(AppModel model) async {
    // Get a reference to the database.
    final db = await (_database ?? _init());
    int count = await _getCount();
    //if we removed all the element on the table
    if (count <= 1) {
      deleteAll();
      return;
    }
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
      List<AppModel> modelsAfterDeletedModel =
          await _propagateUpdate(lastModelBeforeDeletedModel, lastModel);
      _updateAll(modelsAfterDeletedModel);
    }
  }

  Future<List<AppModel>> _propagateUpdate(
      AppModel lastModelBeforeModel, AppModel lastModel) async {
    var modelsAfterModel =
        await _getModelsInRange(lastModelBeforeModel.id, lastModel.id);
    _updateTotalCashInOut(modelsAfterModel[0], lastModelBeforeModel);
    for (int i = 1; i < modelsAfterModel.length; i++) {
      _updateTotalCashInOut(modelsAfterModel[i], modelsAfterModel[i - 1]);
    }
    return modelsAfterModel;
  }

  Future<int> _getCount() async {
    //database connection
    Database db = await (_database ?? _init());
    final x = await db.rawQuery('SELECT COUNT (*) from $_tableName');
    var count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }

  void deleteAll() async {
    _database = _database ?? _init();
    final db = await _database!;
    await db.delete(
      _tableName,
    );
    _alertOnDeleteAll(EmptyAppModel());
  }
}
