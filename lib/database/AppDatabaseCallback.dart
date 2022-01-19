//callback for database

import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';

abstract class AppDatabaseListener<T> {
  //called when database is first initialized,returning all models in the database
  void onDatabaseStarted(List<T> models);
}

abstract class CashBookDatabaseListener<CashBookModel> {
  void onDatabaseStarted(CashBookModelListDetails models);

  //called when done inserting into database and return the inserted model
  void onDatabaseChanged(CashBookModelListDetails models);
}

abstract class ArchiveDatabaseListener<CashBookModel> {
  void onDatabaseStarted(CashBookModelListDetails models);
}

abstract class ParentArchiveDatabaseListener<ParentArchivedModel>
    extends AppDatabaseListener<ParentArchivedModel> {}
