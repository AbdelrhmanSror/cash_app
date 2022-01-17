import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/ArchiveDatabase.dart';
import 'package:debts_app/database/CashBookDatabase.dart';
import 'package:debts_app/database/ParentArchiveDatabase.dart';
import 'package:debts_app/database/models/ArchiveModel.dart';
import 'package:debts_app/database/models/CashBookModel.dart';

class DataBaseRepository {
  final _cashBookDatabase = CashBookDatabase();
  final _archiveDatabase = ArchiveDatabase();
  final _parentArchiveDatabase = ParentArchiveDatabase();

  final List<CashBookDatabaseListener> _cashBookListeners = [];
  final List<ArchiveDatabaseListener> _archiveCashBookListeners = [];
  final List<ParentArchiveDatabaseListener> _parentArchiveCashBookListeners =
      [];

  Future<CashBookModel?> getById(int id) async {
    return await _cashBookDatabase.getById(id);
  }

  void registerArchiveCashBookDatabaseListener(
      ArchiveDatabaseListener listener) {
    _archiveCashBookListeners.add(listener);
  }

  void registerCashBookDatabaseListener(CashBookDatabaseListener listener) {
    _cashBookListeners.add(listener);
  }

  void registerParentArchiveDatabaseListener(
      ParentArchiveDatabaseListener listener) {
    _parentArchiveCashBookListeners.add(listener);
  }

  void _alertOnCashBookInsertion(List<CashBookModel> model) {
    for (var listener in _cashBookListeners) {
      listener.onInsertDatabase(model);
    }
  }

  void _alertOnCashBooDeleteAll(List<CashBookModel> models) {
    for (var listener in _cashBookListeners) {
      listener.onDeleteAllDatabase(models);
    }
  }

  void _alertOnCashBookUpdateAll(List<CashBookModel> models) {
    for (var listener in _cashBookListeners) {
      listener.onUpdateDatabase(models);
    }
  }

  void _alertOnCashBookStart(List<CashBookModel> model) {
    for (var listener in _cashBookListeners) {
      listener.onRetrieveDatabase(model);
    }
  }

  void _alertOnParentArchiveCashBookStart(List<ParentArchivedModel> model) {
    for (var listener in _parentArchiveCashBookListeners) {
      listener.onRetrieveDatabase(model);
    }
  }

  void _alertOnArchiveCashBookStart(List<CashBookModel> model) {
    for (var listener in _archiveCashBookListeners) {
      listener.onRetrieveDatabase(model);
    }
  }

  void insertCashBook(CashBookModel modelToInsert) async {
    await _cashBookDatabase.insert(modelToInsert);
    _alertOnCashBookInsertion(await _retrieveCashBooks());
  }

  void retrieveCashBooks() async {
    _alertOnCashBookStart(await _retrieveCashBooks());
  }

  Future<List<CashBookModel>> _retrieveCashBooks() async {
    return await _cashBookDatabase.retrieveAll(-1);
  }

  void updateCashBook(CashBookModel modelToUpdate) async {
    await _cashBookDatabase.updateModel(modelToUpdate);
    _alertOnCashBookUpdateAll(await _retrieveCashBooks());
  }

  void deleteCashBook(CashBookModel modelToDelete) async {
    await _cashBookDatabase.deleteModel(modelToDelete);
    _alertOnCashBookUpdateAll(await _retrieveCashBooks());
  }

  void retrieveArchivedCashBooks(int parentId) async {
    _alertOnArchiveCashBookStart(await _archiveDatabase.retrieveAll(parentId));
  }

  void retrieveParentArchivedCashBooks() async {
    _alertOnParentArchiveCashBookStart(
        await _parentArchiveDatabase.retrieveAll(-1));
  }

  void archiveCashBooks() async {
    final models = await _cashBookDatabase.retrieveAll(-1);
    int parentId = await _parentArchiveDatabase.createParentId(models);
    await _archiveDatabase.insert(models.reversed.toList(), parentId);
    await _cashBookDatabase.deleteAll();
    _alertOnCashBooDeleteAll(models);
    _alertOnArchiveCashBookStart(models);
  }

  void fetchByDateRange(String from, String to) async {
    print(await _cashBookDatabase.fetchByDateRange(from, to));
    _alertOnCashBookInsertion(
        await _cashBookDatabase.fetchByDateRange(from, to));
  }
}
