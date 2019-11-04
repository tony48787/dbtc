import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/Task.dart';
import 'package:flutter/material.dart';

import 'add_edit_screen.dart';

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
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

}

class Tasks extends StatelessWidget {

  void editRecord(String id, String title, String description, BuildContext context) {
    Task task = Task(title, description);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditScreen(task: task, id: id)),
    );
  }

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
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.check_circle_outline),
                    tooltip: 'Completed today',
                    onPressed: () {
                      print(document.data['title']);
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

}