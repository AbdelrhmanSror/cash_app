import 'dart:async';

import 'package:debts_app/database/ArchiveModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'AppDataModel.dart';
import 'AppDatabaseCallback.dart';

class ArchiveDatabase {
  final String _parentTableName = 'ParentArchiveModels';
  final String _childTableName = 'archiveModels';

  final List<AppDatabaseListener> _listeners = [];
  Future<Database>? _database;

  ArchiveDatabase() {}

  void registerListener(AppDatabaseListener listener) {
    _listeners.add(listener);
  }

  void _alertOnInsertion(AppModel model) {
    for (var listener in _listeners) {
      listener.onInsertDatabase(model);
    }
  }

  void _alertOnStart(List<AppModel> models) {
    for (var listener in _listeners) {
      listener.onStartDatabase(models);
    }
  }

  void _alertOnDeleteAll(List<AppModel> models) {
    for (var listener in _listeners) {
      listener.onDeleteAllDatabase(models);
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

  void _createDb(Database db, int newVersion) async {
    // Run the CREATE TABLE statement on the database.
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $_parentTableName(id INTEGER PRIMARY KEY  NOT NULL)',
    );

    await db.execute(
      'CREATE TABLE IF NOT EXISTS $_childTableName(id INTEGER PRIMARY KEY  NOT NULL,parentModelId INTEGER NOT NULL,date TEXT, totalCashIn DOUBLE,totalCashOut DOUBLE,cash DOUBLE,type TEXT,description TEXT)',
    );
  }

  Future<Database> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'app_database.db'),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    _createDb(await database, 1);
    return database;
  }

  // Define a function that inserts models into the database
  Future<void> insert(List<ArchivedModel> archivedModels) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    _database = _database ?? _init();
    final db = await _database!;
    List<ParentArchivedModel> lastParentModel =
        (await _getModel(_parentTableName, '', [])).toParentArchiveModels();

    final ParentArchivedModel? lastModelInTable =
        lastParentModel.isNotEmpty ? lastParentModel[0] : null;
    //we increment the id of newly inserted value by 1  based on last model in table.
    final parentModel = ParentArchivedModel(
        id: (lastModelInTable == null ? 1 : lastModelInTable.id + 1));
    Batch batch = db.batch();
    batch.insert(
      _parentTableName,
      parentModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var model in archivedModels) {
      model.parentModelId = parentModel.id;
      batch.insert(
        _childTableName,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$_childTableName" WHERE "parentModelId"=${parentModel.id} ORDER BY "id" DESC');

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<ArchivedModel> models = maps.toArchivedModels();
    print(models);
  }

  // A method that retrieves latest model from the  table.
  Future<List<Map<String, dynamic>>> _getModel(String tableName,
      String whereCondition, List<Object> whereArguments) async {
    _database = _database ?? _init();
    final db = await _database!;
    String whereClause = '';
    if (whereCondition.isNotEmpty) whereClause = 'WHERE $whereCondition';
    // Query the table for  The last model in list.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM "$tableName"  $whereClause ORDER BY "id" DESC LIMIT 1',
        whereArguments);
    return maps;
  }
}
