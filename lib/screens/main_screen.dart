import 'package:dbtc/blocs/auth/auth.dart';
import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/screens/calendar_sub_screen.dart';
import 'package:dbtc/screens/home_sub_screen.dart';
import 'package:dbtc/screens/settings_sub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeSubScreen(),
    CalendarSubScreen(),
    SettingsSubScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    String userId = (BlocProvider.of<AuthBloc>(context).state as Authenticated).user.id;
    BlocProvider.of<HabitBloc>(context).add(LoadHabits(userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('DAILY')),
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
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context).translate('SETTINGS'))
          ),
        ],
      ),
    );
  }

}