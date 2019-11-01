import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/Task.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(String task, String note);

class AddEditScreen extends StatefulWidget {

  final databaseReference = Firestore.instance;
  final Task task;
  final String id;
  bool isEditing;

  AddEditScreen({ this.task, this.id }) {
    isEditing = task != null;
  }

  @override
  _AddEditScreenState createState() => _AddEditScreenState();

  void onSave(BuildContext context, String title, String description) async {
    if (isEditing) {
      await databaseReference.collection("tasks")
          .document(this.id)
          .updateData({
            'title': title,
            'description': description
          });
    } else {
      await databaseReference.collection("tasks")
          .add({
        'title': title,
        'description': description
      });
    }

    Navigator.pop(context);
  }
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title;
  String _description;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit" : "Add",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.task.title : '',
                autofocus: !isEditing,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? "This is required"
                      : null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: 16,),
              TextFormField(
                initialValue: isEditing ? widget.task.description : '',
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
                onSaved: (value) => _description = value,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? "Save changes" : "Add task",
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSave(context, _title, _description);
          }
        },
      ),
    );
  }
}