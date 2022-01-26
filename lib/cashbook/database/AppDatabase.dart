import 'dart:async';

import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/CashBookModel.dart';

const String cashBookTable = 'CashBookModel';
const String parentArchiveTable = 'ParentArchiveModels';
const String childArchiveTable = 'archiveModels';

abstract class AppDatabase {
  Future<Database>? _database;

  AppDatabase();

  void _createDb(Database db, int newVersion) async {
    // Run the CREATE TABLE statement on the database.
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $cashBookTable(id INTEGER PRIMARY KEY  NOT NULL , date TEXT, totalCashIn DOUBLE,totalCashOut DOUBLE,cash DOUBLE,type TEXT,description TEXT)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $parentArchiveTable(id INTEGER PRIMARY KEY  NOT NULL,startDate TEXT DEFAULT "" NOT NULL,endDate TEXT DEFAULT "" NOT NULL,balance DOUBLE DEFAULT "0.0" NOT NULL)',
    );

    await db.execute(
      'CREATE TABLE IF NOT EXISTS $childArchiveTable(id INTEGER  NOT NULL,parentModelId INTEGER NOT NULL,date TEXT, totalCashIn DOUBLE,totalCashOut DOUBLE,cash DOUBLE,type TEXT,description TEXT,PRIMARY KEY (id, parentModelId))',
    );
  }

  Future<Database> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_database != null) return _database!;
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

  void updateTotalCashInOut(
      CashBookModel currentModel, CashBookModel previousModel) {
    if (currentModel.type == CASH_IN) {
      currentModel.totalCashIn = previousModel.totalCashIn + currentModel.cash;
      currentModel.totalCashOut = previousModel.totalCashOut;
    } else {
      currentModel.totalCashOut =
          previousModel.totalCashOut + currentModel.cash;
      currentModel.totalCashIn = previousModel.totalCashIn;
    }
  }
}
