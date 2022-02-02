import 'package:flutter/material.dart';

class MyAppBottomNavigation extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const MyAppBottomNavigation(
      {required this.selectedIndex, required this.onItemTapped, Key? key})
      : super(key: key);

  @override
  State<MyAppBottomNavigation> createState() => _MyAppBottomNavigationState();
}

class _MyAppBottomNavigationState extends State<MyAppBottomNavigation> {
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
