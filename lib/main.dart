import 'package:debts_app/bottomNavigation.dart';
import 'package:debts_app/widgets/screens/CashBookScreen.dart';
import 'package:flutter/material.dart';


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

class _MainStatefulWidgetState extends State<MainStatefulWidget> {
  int _selectedIndex = 0;
  final PageController controller = PageController();

  //screen to navigate in bottom navigation bar.
  List<Widget> _widgetOptions() {
    CashBookScreen screen1 = CashBookScreen();

    return [screen1];
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


}
