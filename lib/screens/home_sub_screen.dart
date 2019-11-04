import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/blocs/tasks/tasks_bloc.dart';
import 'package:dbtc/blocs/tasks/tasks_event.dart';
import 'package:dbtc/blocs/tasks/tasks_state.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/Task.dart';
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
      body: Tasks(),
      floatingActionButton: FloatingActionButton(
        onPressed: createRecord,
        tooltip: AppLocalizations.of(context).translate('NEW_TASK'),
        child: Icon(Icons.add),
      ),
    );
  }

}

class Tasks extends StatelessWidget {

  void editRecord(Task task, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditScreen(task: task, id: task.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TasksBloc>(context).add(LoadTasks());

    return BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoadedState) {
            return ListView(
              children: state.tasks.map((task) {
                String dateKey = new DateFormat("yyyy-MM-dd").format(DateTime.now());
                bool isCompleted = task.completions != null && task.completions.contains(dateKey);

                return ListTile(
                  leading: IconButton(
                    icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                    tooltip: AppLocalizations.of(context).translate('COMPLETE_TASK'),
                    onPressed: () {

                      if (isCompleted) {
                        databaseReference
                            .collection("tasks")
                            .document(task.id)
                            .updateData({
                          'completions': FieldValue.arrayRemove([dateKey]),
                          'streak': FieldValue.increment(-1),
                        });

                      } else {
                        databaseReference
                            .collection("tasks")
                            .document(task.id)
                            .updateData({
                          'completions': FieldValue.arrayUnion([dateKey]),
                          'streak': FieldValue.increment(1),
                        });
                      }

                    },
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () {
                    editRecord(task, context);
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