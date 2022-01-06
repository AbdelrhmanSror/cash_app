import 'dart:async';

import 'package:debts_app/utility/Constants.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//callback for database
abstract class AppDatabaseListener {
  void onInsertionDatabase(AppModel model);

  void onDeletionDatabase(AppModel model);

  void onLoadingDatabase(bool active);

  void onStartDatabase(List<AppModel> models);
}

class EmptyAppModel extends AppModel {
  @override
  final String date;
  @override
  final double cash;
  @override
  final double totalCashIn;
  @override
  final double totalCashOut;
  @override
  final String type;

  EmptyAppModel(
      {this.date = '',
      this.cash = 0,
      this.totalCashIn = 0,
      this.totalCashOut = 0,
      this.type = ''})
      : super(
            date: date,
            cash: cash,
            totalCashOut: totalCashOut,
            totalCashIn: totalCashIn,
            type: type);
}

class AppModel {
  final int id;
  final String date;
  final double cash;
  double totalCashIn;
  double totalCashOut;
  final String type;

  AppModel(
      {this.id = 0,
      required this.date,
      this.totalCashIn = 0,
      this.totalCashOut = 0,
      required this.cash,
      required this.type});

  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'cash': cash,
      'totalCashIn': totalCashIn,
      'totalCashOut': totalCashOut,
      'type': type
    };
  }
}

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
      listener.onInsertionDatabase(models);
    }
  }

  void _alertOnStart(List<AppModel> models) {
    for (var listener in _listeners) {
      listener.onStartDatabase(models);
    }
  }

  void _alertOnLoading(bool active) {
    for (var listener in _listeners) {
      listener.onLoadingDatabase(active);
    }
  }

  void _alertOnDelete(AppModel models) {
    for (var listener in _listeners) {
      listener.onDeletionDatabase(models);
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
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, date TEXT, totalCashIn DOUBLE,totalCashOut DOUBLE,cash DOUBLE,type TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts models into the database
  Future<void> insert(AppModel model) async {
    // Insert the model into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    _database = _database ?? _init();
    final db = await _database!;

    // In this case, replace any previous data.
    final AppModel latestModel = await _getLatestModel();
    if (model.type == CASH_IN) {
      model.totalCashIn = latestModel.totalCashIn + model.cash;
      model.totalCashOut = latestModel.totalCashOut;
    } else {
      model.totalCashOut = latestModel.totalCashOut + model.cash;
      model.totalCashIn = latestModel.totalCashIn;
    }

    await db.insert(
      _tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _alertOnInsertion(model);
    print('DONE AFTER INSERTION ${_listeners[0]}');
  }

  // A method that retrieves latest model from the  table.
  Future<AppModel> _getLatestModel() async {
    _database = _database ?? _init();
    final db = await _database!;

    // Query the table for all The model.
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM "$_tableName" ORDER BY "id" DESC LIMIT 1');

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<AppModel> models = List.generate(maps.length, (i) {
      return AppModel(
          id: maps[i]['id'],
          date: maps[i]['date'],
          totalCashIn: maps[i]['totalCashIn'],
          totalCashOut: maps[i]['totalCashOut'],
          cash: maps[i]['cash'],
          type: maps[i]['type']);
    });
    print('MODELS AFTER LATEST');
    if (models.isEmpty) {
      return EmptyAppModel();
    }
    return models[0];
  }

// A method that retrieves all the models from the  table and alert the listeners.
  void retrieveAll() async {
    _alertOnLoading(true);
    // Query the table for all The model.
    _database = _database ?? _init();
    final db = await _database!;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM "$_tableName" ORDER BY "id" DESC');

    // Convert the List<Map<String, dynamic> into a List<AppModel>.
    List<AppModel> models = List.generate(maps.length, (i) {
      return AppModel(
          id: maps[i]['id'],
          date: maps[i]['date'],
          totalCashIn: maps[i]['totalCashIn'],
          totalCashOut: maps[i]['totalCashOut'],
          cash: maps[i]['cash'],
          type: maps[i]['type']);
    });
    if (models.isEmpty) {
      models.add(EmptyAppModel());
    }
    _alertOnLoading(false);
    _alertOnStart(models);
  }

  void deleteAll() async {
    _database = _database ?? _init();
    final db = await _database!;
    // Get a reference to the database.
    // Remove the Dog from the database.
    await db.delete(
      _tableName,
      // Use a `where` clause to delete a specific dog.
      /*where: 'id = ?',*/
      // Pass the Dog's id as a whereArg to prevent SQL injection.
    );
    _alertOnDelete(EmptyAppModel());
  }
}
