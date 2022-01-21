//callback for database

import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';

abstract class CashBookDatabaseListener<CashBookModel> {
  void onDatabaseStarted(CashBookModelListDetails models);

  //called when done inserting into database and return the inserted model
  void onDatabaseChanged(CashBookModelListDetails models);
}

abstract class ArchiveDatabaseListener<CashBookModel> {
  void onDatabaseStarted(CashBookModelListDetails models);
}

abstract class ParentArchiveDatabaseListener<ParentArchivedModel> {
  //called when database is first initialized,returning all models in the database
  void onDatabaseStarted(List<ParentArchivedModel> models);
}
