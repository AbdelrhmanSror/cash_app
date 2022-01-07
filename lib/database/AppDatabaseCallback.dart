//callback for database
import 'AppDataModel.dart';

abstract class AppDatabaseListener {
  void onInsertDatabase(AppModel model);

  void onDeleteAllDatabase(AppModel model);

  void onDeleteDatabase(int id);

  void onUpdateDatabase(AppModel model);

  void onLoadingDatabase(bool active);

  void onStartDatabase(List<AppModel> models);
}
