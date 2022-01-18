//callback for database

abstract class AppDatabaseListener<T> {
  //called when database is first initialized,returning all models in the database
  void onRetrieveDatabase(List<T> models);
}

abstract class CashBookDatabaseListener<CashBookModel>
    extends AppDatabaseListener<CashBookModel> {
  //called when done inserting into database and return the inserted model
  void onInsertDatabase(List<CashBookModel> insertedModels);

  //called when database is cleared and return empty model as indication for empty database
  void onDeleteAllDatabase(List<CashBookModel> emptyModel);

  //called when updating or deleting some models except last model ,returning All models in the database after the update
  void onUpdateDatabase(List<CashBookModel> updatedModels);
}

abstract class ArchiveDatabaseListener<CashBookModel>
    extends AppDatabaseListener<CashBookModel> {}

abstract class ParentArchiveDatabaseListener<ParentArchivedModel>
    extends AppDatabaseListener<ParentArchivedModel> {}
