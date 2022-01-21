import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/ArchiveDatabase.dart';
import 'package:debts_app/database/CashBookDatabase.dart';
import 'package:debts_app/database/ParentArchiveDatabase.dart';
import 'package:debts_app/database/models/ArchiveModel.dart';
import 'package:debts_app/database/models/CashBookModel.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/FilterSharedPreferences.dart';
import 'package:debts_app/utility/dataClasses/Cash.dart';
import 'package:debts_app/utility/dataClasses/CashbookModeldetails.dart';
import 'package:debts_app/utility/dataClasses/Date.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _alertOnCashBookChanged(CashBookModelListDetails model) {
    for (var listener in _cashBookListeners) {
      listener.onDatabaseChanged(model);
    }
  }

  void _alertOnCashBookStart(CashBookModelListDetails model) {
    for (var listener in _cashBookListeners) {
      listener.onDatabaseStarted(model);
    }
  }

  void _alertOnParentArchiveCashBookStart(List<ParentArchivedModel> model) {
    for (var listener in _parentArchiveCashBookListeners) {
      listener.onDatabaseStarted(model);
    }
  }

  void _alertOnArchiveCashBookStart(CashBookModelListDetails model) {
    for (var listener in _archiveCashBookListeners) {
      listener.onDatabaseStarted(model);
    }
  }

  // A method that retrieves max and min cash for the data in the database.
  Future<CashRange?> getMinMaxCash() {
    return _cashBookDatabase.getMinMaxCash();
  }

  // A method that retrieves max and min cash for the data in the database.
  Future<Date?> getMinMaxDate() {
    return _cashBookDatabase.getMinMaxDate();
  }

  void insertCashBook(CashBookModel modelToInsert) async {
    await _cashBookDatabase.insert(modelToInsert);
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  void retrieveCashBooks() async {
    FilterSharedPreferences.retrievedFilterPreferences(
        (date, type, cashRange, sortFilter, dateType) async {
      _alertOnCashBookStart((await _retrieveCashBooks(
          date: date,
          type: type,
          cashRange: cashRange,
          sortFilter: sortFilter)));
    });
  }

  Future<CashBookModelListDetails> _retrieveCashBooks(
      {Date? date,
      TypeFilter? type,
      CashRange? cashRange,
      SortFilter? sortFilter}) async {
    return await _cashBookDatabase.retrieveAll(
        date: date, type: type, cashRange: cashRange, sortFilter: sortFilter);
  }

  void updateCashBook(CashBookModel modelToUpdate) async {
    await _cashBookDatabase.updateModel(modelToUpdate);
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  void deleteCashBook(CashBookModel modelToDelete) async {
    await _cashBookDatabase.deleteModel(modelToDelete);
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  void retrieveArchivedCashBooks(int parentId) async {
    _alertOnArchiveCashBookStart(await _archiveDatabase.retrieveAll(parentId));
  }

  void retrieveParentArchivedCashBooks() async {
    _alertOnParentArchiveCashBookStart(
        await _parentArchiveDatabase.retrieveAll(-1));
  }

  //remember to archive based on current filter
  void archiveCashBooks(CashBookModelListDetails models) async {
    final listOfIds = List.generate(models.models.length, (i) {
      return models.models[i].id;
    });
    //because models may be ordered in some way so we need to revert it back to its genuine order which is in ascending by id
    final orderedModels =
        await _cashBookDatabase.getAllWithID(listOfIds: listOfIds);
    int parentId = await _parentArchiveDatabase.createParentId(orderedModels);
    await _archiveDatabase.insert(orderedModels.models, parentId);
    await _cashBookDatabase.deleteAll(orderedModels.models);
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  void retrieveFilteredCashBooks() async {
    FilterSharedPreferences.retrievedFilterPreferences(
        (date, type, cashRange, sortFilter, dateType) async {
      print(
          'database changed $date  $type   $cashRange $sortFilter  $dateType ');

      _alertOnCashBookChanged(await _retrieveCashBooks(
          date: date,
          type: type,
          cashRange: cashRange,
          sortFilter: sortFilter));
    });
  }

  Future<void> clearFilter() async {
    await FilterSharedPreferences.clearFilter();
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  Future<void> setDateTypeInPreferences(DateFilter dateFilter) async {
    FilterSharedPreferences.setDateTypeInPreferences(dateFilter);
  }

  Future<void> setTypeInPreferences(TypeFilter typeFilter) async {
    FilterSharedPreferences.setTypesInPreferences(typeFilter);
  }

  Future<void> setCashRangeInPreferences(CashRange cashRange) async {
    final prefs = await SharedPreferences.getInstance();
    FilterSharedPreferences.setCashRangeInPreferences(prefs, cashRange);
  }

  Future<void> setDateRangeInPreferences(Date date) async {
    FilterSharedPreferences.setDateInPreferences(date);
  }

  Future<void> setSortInPreferences(SortFilter sortFilter) async {
    FilterSharedPreferences.setSortInPreferences(sortFilter);
  }
}
