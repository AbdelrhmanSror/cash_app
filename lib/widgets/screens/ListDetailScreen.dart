import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/main.dart';
import 'package:debts_app/utility/Constants.dart';
import 'package:debts_app/utility/DateFormatter.dart';
import 'package:debts_app/utility/Utility.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/CompositeWidget.dart';
import 'package:debts_app/widgets/partial/RoundedButton.dart';
import 'package:debts_app/widgets/screens/CashBookScreen.dart';
import 'package:flutter/material.dart';

import 'CashScreen.dart';

class ListDetailScreen extends StatefulWidget {
  ListDetailScreen({required this.model, Key? key}) : super(key: key);
  AppModel model;

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
        toolbarHeight: 70,
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
            padding: const EdgeInsets.only(left: 20, top: 4.0),
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

  RoundedButton buildEditButton() {
    return RoundedButton(
        text: AppTextWithDot(
          text: 'EDIT',
          fontSize: 16,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        radius: 2.0,
        paddingTop: 16,
        paddingBottom: 16,
        paddingLeft: 16,
        paddingRight: 16,
        onPressed: () async {
          AppModel result = EmptyAppModel();
          if (widget.model.type == CASH_IN) {
            result = await Navigator.of(context).push(
                Utility.createAnimationRoute(
                    CashInScreen(
                        operationType: UPDATE, modelToEdit: widget.model),
                    const Offset(0.0, 1.0),
                    Offset.zero,
                    Curves.ease));
          } else {
            result =
                await Navigator.of(context).push(Utility.createAnimationRoute(
                    CashOutScreen(
                      operationType: UPDATE,
                      modelToEdit: widget.model,
                    ),
                    const Offset(0.0, 1.0),
                    Offset.zero,
                    Curves.ease));
          }
          setState(() {
            widget.model = result;
          });
        });
  }

  RoundedButton buildDeleteButton(BuildContext context) {
    return RoundedButton(
        text: AppTextWithDot(
          text: 'DELETE',
          fontSize: 16,
          color: Colors.white,
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
                    appDatabase.deleteModel(widget.model);
                    Navigator.pop(context);
                    Navigator.of(context).pop(Utility.createAnimationRoute(
                        const CashBookScreen(models: []),
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
            text: DateFormatter.getDateTimeRepresentation(
                DateTime.parse(widget.model.date)),
            color: const Color(0xFF281361),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        const Divider(height: 20, color: Colors.white),
        AppTextWithDot(
            text: widget.model.type, color: Colors.blueGrey.shade200),
        const Divider(height: 3, color: Colors.white),
        AppTextWithDot(
            text: '${widget.model.cash} EGP',
            color:
                widget.model.type == CASH_OUT ? Colors.red : Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 25),
        const Divider(height: 20, color: Colors.white),
        CompositeWidget(width: 250, widgets: [
          AppTextWithDot(
            text: 'Balance  ',
            color: Colors.blueGrey.shade200,
            fontSize: 12,
          ),
          AppTextWithDot(
            fontSize: 12,
            text: '${widget.model.getBalance().abs()}',
            color:
                widget.model.getBalance() < 0 ? Colors.red : Colors.greenAccent,
          )
        ]),
        const Divider(
          height: 20,
          color: Colors.white,
        ),
        AppTextWithDot(
            text: 'Note',
            color: Colors.blue,
            fontSize: 16, //show alert on textfield
            fontWeight: FontWeight.bold),
        const Divider(height: 5, color: Colors.white),
        AppTextWithDot(
          text: widget.model.description,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        )
      ],
      vertical: true,
      width: 250,
    );
  }
}
