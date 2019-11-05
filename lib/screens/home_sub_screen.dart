import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'add_edit_screen.dart';

final databaseReference = Firestore.instance;

class HomeSubScreen extends StatefulWidget {

  @override
  _HomeSubScreenState createState() => _HomeSubScreenState();

}


class _HomeSubScreenState extends State<HomeSubScreen> {

  List<DocumentSnapshot> listData = new List<DocumentSnapshot>();

  void createRecord() {
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
        onPressed: createRecord,
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
      MaterialPageRoute(builder: (context) => AddEditScreen(habit: habit, id: habit.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitsLoadedState) {
            return ListView(
              children: state.habits.map((habit) {
                String dateKey = new DateFormat("yyyy-MM-dd").format(DateTime.now());
                bool isCompleted = habit.completions != null && habit.completions.contains(dateKey);

                return ListTile(
                  leading: IconButton(
                    icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                    tooltip: AppLocalizations.of(context).translate('COMPLETE_HABIT'),
                    onPressed: () {

                      if (isCompleted) {
                        databaseReference
                            .collection("tasks")
                            .document(habit.id)
                            .updateData({
                          'completions': FieldValue.arrayRemove([dateKey]),
                          'streak': FieldValue.increment(-1),
                        });

                      } else {
                        databaseReference
                            .collection("tasks")
                            .document(habit.id)
                            .updateData({
                          'completions': FieldValue.arrayUnion([dateKey]),
                          'streak': FieldValue.increment(1),
                        });
                      }

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

          return Text("Loading");
        }
    );
  }

}