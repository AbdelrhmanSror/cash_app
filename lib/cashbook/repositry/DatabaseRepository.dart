import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/ArchiveDatabase.dart';
import 'package:debts_app/cashbook/database/CashBookDatabase.dart';
import 'package:debts_app/cashbook/database/ParentArchiveDatabase.dart';
import 'package:debts_app/cashbook/database/models/ArchiveModel.dart';
import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';
import 'package:debts_app/cashbook/utility/FilterSharedPreferences.dart';
import 'package:debts_app/cashbook/utility/dataClasses/Cash.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/utility/dataClasses/Date.dart';
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
  Future<CashRange> getMinMaxCash() async {
    return (await _cashBookDatabase.getMinMaxCash()) ?? CashRange(0, 0);
  }

  // A method that retrieves max and min cash for the data in the database.
  Future<Date> getMinMaxDate() async {
    return (await _cashBookDatabase.getMinMaxDate()) ??
        Date(DateTime.now().toString(), DateTime.now().toString());
  }

  Future<void> insertCashBook(CashBookModel modelToInsert) async {
    await _cashBookDatabase.insert(modelToInsert);
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  void retrieveCashBooks() async {
    _alertOnCashBookStart(await _retrieveCashBooks());
  }

  Future<CashBookModelListDetails> _retrieveCashBooks() async {
    final date = await getDateFromPreferences();
    final type = await getTypesFromPreferences();
    final cashRange = await getCashRangeFromPreferences();
    final sortFilter = await getSortFromPreferences();
    CashBookModelListDetails cashBookModelListDetails =
        await _cashBookDatabase.retrieveAll(date, type, cashRange, sortFilter);
    return cashBookModelListDetails;
  }

  Future<void> updateCashBook(CashBookModel modelToUpdate) async {
    await _cashBookDatabase.update(modelToUpdate);
    _alertOnCashBookChanged(await _retrieveCashBooks());
  }

  Future<void> deleteCashBook(CashBookModel modelToDelete) async {
    await _cashBookDatabase.delete(modelToDelete);
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
    _alertOnCashBookChanged(await _retrieveCashBooks());
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

  Future<void> setDateRangeInPreferences(Date? date) async {
    if (date == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(DATE_START_RANGE);
      await prefs.remove(DATE_END_RANGE);
    } else {
      FilterSharedPreferences.setDateInPreferences(date);
    }
  }

  Future<void> setSortInPreferences(SortFilter sortFilter) async {
    FilterSharedPreferences.setSortInPreferences(sortFilter);
  }

  Future<DateFilter> getDateTypeFromPreferences() async {
    return FilterSharedPreferences.getDateTypeFromPreferences();
  }

  Future<TypeFilter> getTypesFromPreferences() async {
    return FilterSharedPreferences.getTypesFromPreferences();
  }

  Future<SortFilter> getSortFromPreferences() async {
    return FilterSharedPreferences.getSortFromPreferences();
  }

  Future<Date> getDateFromPreferences() async {
    final date = await getMinMaxDate();
    return FilterSharedPreferences.getDateFromPreferences(Date(
        DateUtility.removeTimeFromDate(DateTime.parse(date.firstDate)),
        DateUtility.removeTimeFromDate(DateTime.parse(date.lastDate))));
  }

  Future<CashRange> getCashRangeFromPreferences() async {
    return FilterSharedPreferences.getCashRangeFromPreferences(
        await getMinMaxCash());
  }

  Future<void> flipArrowState(FilterArrowState filterArrowState) async {
    await FilterSharedPreferences.flipArrowState(filterArrowState);
  }

  Future<bool> getArrowState(FilterArrowState filterArrowState) async {
    return FilterSharedPreferences.getArrowState(filterArrowState);
  }
}
