import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/Task.dart';
import 'package:dbtc/screens/add_edit_screen.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final databaseReference = Firestore.instance;

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  void createRecord() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEditScreen()),
      );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MainScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Daily"),
        centerTitle: true,
      ),
      body: Tasks(),
      floatingActionButton: FloatingActionButton(
        onPressed: createRecord,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class Tasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                String dateKey = new DateFormat("yyyy-MM-dd").format(DateTime.now());

                List completions = document['completions'] as List;
                bool isCompleted = completions != null && completions.contains(dateKey);

                return ListTile(
                  leading: IconButton(
                    icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                    tooltip: 'Completed today',
                    onPressed: () {
                      if (isCompleted) {
                        databaseReference
                            .collection("tasks")
                            .document(document.documentID)
                            .updateData({
                          'completions': FieldValue.arrayRemove([dateKey]),
                          'streak': FieldValue.increment(-1),
                        });
                      } else {
                        databaseReference
                            .collection("tasks")
                            .document(document.documentID)
                            .updateData({
                          'completions': FieldValue.arrayUnion([dateKey]),
                          'streak': FieldValue.increment(1),
                        });
                      }

                    },
                  ),
                  title: Text(document['title']),
                  subtitle: Text(document['description']),
                  onTap: () {
                    editRecord(document.documentID, document['title'], document['description'], context);
                },
                );
              }).toList(),
            );
        }
      },
    );
  }

  void editRecord(String id, String title, String description, BuildContext context) {
    Task task = Task(title, description);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditScreen(task: task, id: id)),
    );
  }
}