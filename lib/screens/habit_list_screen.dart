import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitListScreen extends StatelessWidget {
  
  final DateTime date;
  final List<Habit> habits;
  
  HabitListScreen(this.date, this.habits);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY).format(date)),
      ),
      body: ListView(
        children: habits.map((habit) {
          String dateKey = DateFormat('yyyy-MM-dd').format(date);
          Map<String, bool> completedAtDate = habit.completedAtDate ?? Map();
          bool isCompleted = completedAtDate[dateKey] != null && completedAtDate[dateKey];

          return ListTile(
            leading: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
            title: Text(habit.title),
            subtitle: Text(habit.description),
          );
        }).toList(),
      ),
    );
  }
}