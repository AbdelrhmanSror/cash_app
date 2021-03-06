import 'package:debts_app/cashbook/database/AppDatabaseCallback.dart';
import 'package:debts_app/cashbook/database/models/ArchiveModel.dart';
import 'package:debts_app/cashbook/utility/DateUtility.dart';
import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/cashbook/widgets/partial/circularButton.dart';
import 'package:debts_app/main.dart';
import 'package:flutter/material.dart';

class OperationArchiveParentListScreen extends StatefulWidget {
  const OperationArchiveParentListScreen({required this.onPressed, Key? key})
      : super(key: key);

  final Function(int parentId) onPressed;

  @override
  State<OperationArchiveParentListScreen> createState() =>
      _OperationArchiveParentListScreenWidgetState();
}

class _OperationArchiveParentListScreenWidgetState
    extends State<OperationArchiveParentListScreen>
    implements ParentArchiveDatabaseListener<ParentArchivedModel> {
  List<ParentArchivedModel> models = [];

  @override
  void initState() {
    super.initState();
    databaseRepository.registerParentArchiveDatabaseListener(this);
    databaseRepository.retrieveParentArchivedCashBooks();
  }

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
        title: const Text(
          'OPERATIONS ARCHIVE',
          style: TextStyle(
              color: Color(0xFF3345A6),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.separated(
        itemCount: models.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 0, color: Colors.grey),
        itemBuilder: (BuildContext context, int index) => _buildRow(index));
  }

  Widget _buildRow(int index) {
    return InkWell(
        child: OperationTile(model: models[index]),
        onTap: () {
          widget.onPressed(models[index].id);
        });
  }

  @override
  void onDatabaseStarted(List<ParentArchivedModel> models) {
    if (mounted) {
      setState(() {
        this.models = models;
      });
    }
  }
}

class OperationTile extends StatelessWidget {
  const OperationTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ParentArchivedModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircularButton(
                icon: Icons.book,
                iconColor: const Color(0xFF3345A6),
                backgroundColor: Colors.blue.shade50,
              ),
            ),
            Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AppTextWithDot(
                      text:
                          'From ${DateUtility.getDateRepresentation(DateTime.parse(model.startDate))}',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.blueGrey.shade300),
                    ),
                  ),
                  AppTextWithDot(
                    text:
                        'To ${DateUtility.getDateRepresentation(DateTime.parse(model.endDate))}',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.blueGrey.shade300),
                  ),
                ])
          ]),
          Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: AppTextWithDot(
              text: '${Utility.formatCashNumber(model.balance.abs())} EGP',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: model.balance < 0 ? Colors.red : Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }
}
