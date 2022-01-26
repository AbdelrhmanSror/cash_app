import 'package:debts_app/cashbook/database/models/CashBookModel.dart';
import 'package:debts_app/cashbook/utility/Constants.dart';
import 'package:debts_app/cashbook/utility/Extensions.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/cashbook/widgets/partial/RoundedButton.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'CashBookScreen.dart';
import 'CashScreen.dart';

class ListDetailScreen extends StatefulWidget {
  ListDetailScreen(
      {required this.model,
      this.hideEditButton = false,
      this.hideDeleteButton = false,
      Key? key})
      : super(key: key);
  CashBookModel model;
  bool hideEditButton;
  bool hideDeleteButton;

  @override
  State<ListDetailScreen> createState() {
    return _ListDetailScreenState();
  }
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.blue, //change your color here
        ),
        title: Text(
          widget.model.type.toUpperCase(),
          style: const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 4.0, bottom: 8),
            child: buildDetailsWidget(),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 8, bottom: 32),
                  child: buildDeleteButton(context),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 8, right: 16, bottom: 32),
                  child: buildEditButton(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildEditButton() {
    return RoundedTextButton(
        hide: widget.hideEditButton,
        text: AppTextWithDot(
          text: 'EDIT',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        radius: 2.0,
        paddingTop: 16,
        paddingBottom: 16,
        paddingLeft: 16,
        paddingRight: 16,
        onPressed: () async {
          CashBookModel? result /*EmptyCashBookModel()*/;
          if (widget.model.type == CASH_IN) {
            await Navigator.of(context).push(Utility.createAnimationRoute(
                CashInScreen(
                  operationType: OperationType.UPDATE,
                  modelToEdit: widget.model,
                ),
                const Offset(0.0, 1.0),
                Offset.zero,
                Curves.ease));
          } else {
            await Navigator.of(context).push(Utility.createAnimationRoute(
                CashOutScreen(
                    operationType: OperationType.UPDATE,
                    modelToEdit: widget.model),
                const Offset(0.0, 1.0),
                Offset.zero,
                Curves.ease));
          }
          //get updated model
          result = await databaseRepository.getById(widget.model.id);
          setState(() {
            widget.model = result ?? widget.model;
          });
        });
  }

  Widget buildDeleteButton(BuildContext context) {
    return RoundedTextButton(
        hide: widget.hideDeleteButton,
        text: const AppTextWithDot(
          text: 'DELETE',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        radius: 2.0,
        paddingTop: 16,
        paddingBottom: 16,
        paddingLeft: 16,
        paddingRight: 16,
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              elevation: 20,
              content: const Text(
                'Do you want to delete this operation?',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('CANCEL',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    databaseRepository.deleteCashBook(widget.model);
                    Navigator.pop(context);
                    Navigator.of(context).pop(Utility.createAnimationRoute(
                        const CashBookScreen(),
                        const Offset(0.1, 0.0),
                        Offset.zero,
                        Curves.ease));
                  },
                  child:
                      const Text('DELETE', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        });
  }

  CompositeWidget buildDetailsWidget() {
    return CompositeWidget(
      widgets: [
        AppTextWithDot(
          text: widget.model.date.getFormattedDateTime(),
          style: TextStyle(
              color: const Color(0xFF281361),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const Divider(height: 20, color: Colors.white),
        AppTextWithDot(
          text: widget.model.type,
          style: TextStyle(color: Colors.blueGrey.shade200),
        ),
        const Divider(height: 3, color: Colors.white),
        AppTextWithDot(
          text: '${widget.model.cash} EGP',
          style: TextStyle(
              color: widget.model.type == CASH_OUT
                  ? Colors.red
                  : Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        const Divider(height: 20, color: Colors.white),
        CompositeWidget(width: 250, widgets: [
          AppTextWithDot(
            text: 'Balance  ',
            style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12),
          ),
          AppTextWithDot(
            text: '${widget.model.getBalance().abs()}',
            style: TextStyle(
              fontSize: 12,
              color: widget.model.getBalance() < 0
                  ? Colors.red
                  : Colors.greenAccent,
            ),
          )
        ]),
        const Divider(
          height: 20,
          color: Colors.white,
        ),
        const AppTextWithDot(
          text: 'Note',
          style: TextStyle(
              color: Colors.blue,
              fontSize: 16, //show alert on textfield
              fontWeight: FontWeight.bold),
        ),
        const Divider(height: 5, color: Colors.white),
        AppTextWithDot(
          maxLines: 8,
          text: widget.model.description,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
        )
      ],
      vertical: true,
      width: double.infinity,
    );
  }
}
