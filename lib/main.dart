import 'package:debts_app/bottomNavigation.dart';
import 'package:debts_app/database/AppDataModel.dart';
import 'package:debts_app/database/AppDatabaseCallback.dart';
import 'package:debts_app/database/ArchiveDatabase.dart';
import 'package:debts_app/widgets/screens/CashBookScreen.dart';
import 'package:debts_app/widgets/screens/OperationArchiveScreen.dart';
import 'package:flutter/material.dart';

import 'database/AppDatabase.dart';

final appDatabase = AppDatabase();
final archiveDatabase = ArchiveDatabase();

void main() {
  runApp(const MainStatelessWidget());
}

class MainStatelessWidget extends StatelessWidget {
  const MainStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'debts',
        home: Scaffold(body: MainStatefulWidget()));
  }
}

class MainStatefulWidget extends StatefulWidget {
  const MainStatefulWidget({Key? key}) : super(key: key);
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  State<MainStatefulWidget> createState() {
    return _MainStatefulWidgetState();
  }
}

class _MainStatefulWidgetState extends State<MainStatefulWidget>
    with AppDatabaseListener {
  int _selectedIndex = 0;
  final PageController controller = PageController();
  List<AppModel> _models = [];

  //screen to navigate in bottom navigation bar.
  List<Widget> _widgetOptions() {
    CashBookScreen screen1 = CashBookScreen(models: _models);
    OperationArchiveScreen screen2 = OperationArchiveScreen(models: _models);

    return [screen1, screen2];
  }

  //updating the index when tap on bar on bottom navigation so the widget rebuilds its self,
  // bottom navigation update its colors and status.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        title: const Text(
          'DEBTS',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: PageView(
        children: _widgetOptions(),
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        scrollDirection: Axis.horizontal,
      ),
      bottomNavigationBar: MyBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //register this widget as listener to the any updates happen in the database
    appDatabase.registerListener(this);
    //retrieve all the data in the database to initialize our app
    appDatabase.retrieveAll();
  }

  @override
  void onInsertDatabase(AppModel insertedModel) {
    if (!mounted) return;
    setState(() {
      _models.insert(0, insertedModel);
    });
  }

  @override
  void onStartDatabase(List<AppModel> models) {
/*
    print('start cash book screen');
*/
    if (!mounted) return;
    setState(() {
      //initial setup for models
      _models = models;
    });
  }

  @override
  void onDeleteAllDatabase(List<AppModel> deletedModels) {
    if (!mounted) return;
    setState(() {
      _models = deletedModels;
    });
  }

  @override
  void onLastRowDeleted() {
    if (!mounted) return;
    setState(() {
      //remove last value in the list
      //we remove last value by first index because we retrieve all value from database in descending order
      _models.removeAt(0);
    });
  }

  @override
  void onUpdateAllDatabase(List<AppModel> updatedModels) {
    if (!mounted) return;
    setState(() {
      _models = updatedModels;
    });
  }

  @override
  void onUpdateDatabase(AppModel model) {
    if (!mounted) return;
    setState(() {
      _models[getIndex(model)] = model;
    });
  }

  int getIndex(AppModel model) {
    var index = 0;
    for (int i = 0; i < _models.length; i++) {
      if (model.id == _models[i].id) {
        index = i;
        break;
      }
    }
    return index;
  }
}
