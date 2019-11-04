import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/screens/calendar_sub_screen.dart';
import 'package:dbtc/screens/home_sub_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeSubScreen(),
    CalendarSubScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('DAILY')),
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(AppLocalizations.of(context).translate('HOME'))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              title: Text(AppLocalizations.of(context).translate('CALENDAR'))
          )
        ],
      ),
    );
  }

}