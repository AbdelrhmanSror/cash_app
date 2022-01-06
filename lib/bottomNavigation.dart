import 'package:flutter/material.dart';

class MyBottomNavigation extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const MyBottomNavigation(
      {required this.selectedIndex, required this.onItemTapped, Key? key})
      : super(key: key);

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'CashBook',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'CreditBook',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.blue,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      onTap: widget.onItemTapped,
    );
  }
}
