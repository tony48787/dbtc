import 'package:dbtc/blocs/auth/auth.dart';
import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'add_edit_screen.dart';

class HomeSubScreen extends StatelessWidget {

  void createRecord(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Habits(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createRecord(context),
        tooltip: AppLocalizations.of(context).translate('NEW_HABIT'),
        child: Icon(Icons.add),
      ),
    );
  }

}

class Habits extends StatelessWidget {

  void editRecord(Habit habit, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditScreen(habit: habit)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = (BlocProvider.of<AuthBloc>(context).state as Authenticated).user.id;

    return BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitsLoadedState) {
            return ListView(
              children: state.habits.map((habit) {
                String dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
                Map<String, bool> completedAtDate = habit.completedAtDate ?? Map();
                bool isCompleted = completedAtDate[dateKey] != null && completedAtDate[dateKey];

                return ListTile(
                  leading: IconButton(
                    icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                    tooltip: AppLocalizations.of(context).translate('COMPLETE_HABIT'),
                    onPressed: () {
                      isCompleted ? completedAtDate.remove(dateKey) : completedAtDate[dateKey] = true;

                      Habit newHabit = habit.copyWith(completedAtDate: completedAtDate);
                      BlocProvider.of<HabitBloc>(context).add(UpdateHabit(userId, newHabit));
                    },
                  ),
                  title: Text(habit.title),
                  subtitle: Text(habit.description),
                  onTap: () {
                    editRecord(habit, context);
                  },
                );
              }).toList(),
            );
          }

          return Text('Loading');
        }
    );
  }

}