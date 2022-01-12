import 'package:debts_app/database/AppDatabase.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/models/ArchiveModel.dart';
import 'package:debts_app/widgets/partial/AppTextWithDots.dart';
import 'package:debts_app/widgets/partial/circularButton.dart';
import 'package:flutter/material.dart';

class OperationArchiveParentListScreen extends StatefulWidget {
  OperationArchiveParentListScreen({required this.onPressed, Key? key})
      : super(key: key);

  List<ParentArchivedModel> models = [];
  final Function(int parentId) onPressed;

  @override
  State<OperationArchiveParentListScreen> createState() =>
      _OperationArchiveParentListScreenWidgetState();
}

class _OperationArchiveParentListScreenWidgetState
    extends State<OperationArchiveParentListScreen>
    implements ParentArchiveDatabaseListener<ParentArchivedModel> {
  @override
  void initState() {
    super.initState();
    parentArchiveDatabase.registerListener(this);
    parentArchiveDatabase.retrieveAll();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.blue, //change your color here
          ),
          title: const Text(
            'OPERATIONS ARCHIVE',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: _buildSuggestions(),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.separated(
        itemCount: widget.models.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 0, color: Colors.grey),
        itemBuilder: (BuildContext context, int index) => _buildRow(index));
  }

  Widget _buildRow(int index) {
    return InkWell(
        child: OperationTile(model: widget.models[index]),
        onTap: () {
          widget.onPressed(widget.models[index].id);
        });
  }

  @override
  void onRetrieveDatabase(List<ParentArchivedModel> models) {
    print('modeslsss  $models');
    if (mounted) {
      setState(() {
        widget.models = models;
      });
    }
  }
}

class OperationTile extends StatelessWidget {
  OperationTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ParentArchivedModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircularButton(
                icon: Icons.book,
                iconColor: Colors.blue,
                backgroundColor: Colors.blue.shade50,
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                constraints: const BoxConstraints(minWidth: 1, maxWidth: 180),
                child: AppTextWithDot(
                    text: model.startDate,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF281361)),
              ),
              AppTextWithDot(
                  text: model.endDate,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF281361)),
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              constraints: const BoxConstraints(minWidth: 1, maxWidth: 100),
              child: AppTextWithDot(
                  text: '${model.balance} EGP',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: model.balance < 0 ? Colors.red : Colors.greenAccent),
            ),
          ]),
        ],
      ),
    );
  }
}
