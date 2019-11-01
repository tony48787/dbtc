import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/screens/add_edit_screen.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = Firestore.instance;

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  int _counter = 0;
  List<DocumentSnapshot> listData = new List<DocumentSnapshot>();

  void createRecord() async {
//    await databaseReference.collection("tasks")
//        .add({
//      'title': 'Mastering Flutter',
//      'description': 'Programming Guide for Dart'
//    });
//
//    QuerySnapshot snapshot = await databaseReference
//        .collection("tasks")
//        .getDocuments();
//
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      listData = snapshot.documents;
//
//      _counter++;
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
      ),
      body: Text("ListView"),
      floatingActionButton: FloatingActionButton(
        onPressed: createRecord,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Tasks extends StatelessWidget {
  // backing data
  final List<DocumentSnapshot> listData;

  // In the constructor, require a Todo
  Tasks({Key key, @required this.listData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(listData[index].data["title"]),
          subtitle: Text(listData[index].data["description"]),
        );
      },
    );
  }
}