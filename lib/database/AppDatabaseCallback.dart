//callback for database
import 'AppDataModel.dart';

abstract class AppDatabaseListener {
  //called when done inserting into database and return the inserted model
  void onInsertDatabase(AppModel model);

  //called when database is cleared and return empty model as indication for empty database
  void onDeleteAllDatabase(EmptyAppModel model);

  //called when last row  deleted from database ,because it won't affect any other row
  void onLastRowDeleted();

  //called when updating or deleting some models except last model ,returning All models in the database after the update
  void onUpdateAllDatabase(List<AppModel> models);

  //called when last row  updated or if there was an update that won't affect other model's data in the database,
  // otherwise @onUpdateAllDatabase will be called
  void onUpdateDatabase(AppModel model);

  //called when database is first initialized,returning all models in the database
  void onStartDatabase(List<AppModel> models);
}
