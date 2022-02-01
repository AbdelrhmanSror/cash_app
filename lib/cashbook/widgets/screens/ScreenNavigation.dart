import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:flutter/cupertino.dart';

import 'ArchiveModalSheetScreen.dart';
import 'CashListScreen.dart';
import 'CashScreen.dart';
import 'ListDetailScreen.dart';
import 'OperationArchiveParentListScreen.dart';
import 'OperationArchiveScreen.dart';

class ScreenNavigation {
  static void navigateToCashListScreen(BuildContext context) {
    Navigator.of(context).push(Utility.createAnimationRoute(
        const CashListScreen(),
        const Offset(1.0, 0.0),
        Offset.zero,
        Curves.ease));
  }

  static Future<void> navigateToEditScreen(
      BuildContext context, CashBookModel model) async {
    if (model.type == TypeFilter.CASH_IN.value) {
      await Navigator.of(context).push(Utility.createAnimationRoute(
          CashInScreen(
            operationType: OperationType.UPDATE,
            modelToEdit: model,
          ),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    }
    if (model.type == TypeFilter.CASH_OUT.value) {
      await Navigator.of(context).push(Utility.createAnimationRoute(
          CashOutScreen(
            operationType: OperationType.UPDATE,
            modelToEdit: model,
          ),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    }
  }

  static void navigateToCashOutScreen(
      BuildContext context, OperationType type) {
    Navigator.of(context).push(Utility.createAnimationRoute(
        CashOutScreen(operationType: type),
        const Offset(1.0, 0.0),
        Offset.zero,
        Curves.ease));
  }

  static void navigateToCashInScreen(BuildContext context, OperationType type) {
    Navigator.of(context).push(Utility.createAnimationRoute(
        CashInScreen(operationType: type),
        const Offset(1.0, 0.0),
        Offset.zero,
        Curves.ease));
  }

  static void navigateToListDetailScreen(
      BuildContext context, CashBookModel model) {
    Navigator.of(context).push(Utility.createAnimationRoute(
        ListDetailScreen(model: model),
        const Offset(0.0, 1.0),
        Offset.zero,
        Curves.ease));
  }

  static void navigateToArchiveModalSheetScreen(
      BuildContext context, CashBookModelListDetails models) {
    Utility.createModalSheet(context, ArchiveModalSheetScreen(models: models));
  }

  static void navigateToParentArchiveScreen(BuildContext context) {
    Navigator.of(context).push(Utility.createAnimationRoute(
        OperationArchiveParentListScreen(onPressed: (parentId) {
      Navigator.of(context).push(Utility.createAnimationRoute(
          OperationArchiveScreen(parentId: parentId),
          const Offset(1.0, 0.0),
          Offset.zero,
          Curves.ease));
    }), const Offset(0.0, 1.0), Offset.zero, Curves.ease));
  }
}
