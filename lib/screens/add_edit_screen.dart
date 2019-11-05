import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/habit.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(String habit, String note);

class AddEditScreen extends StatefulWidget {

  final databaseReference = Firestore.instance;
  final Habit habit;
  final String id;
  bool isEditing;

  AddEditScreen({ this.habit, this.id }) {
    isEditing = habit != null;
  }

  @override
  _AddEditScreenState createState() => _AddEditScreenState();

  void onSave(BuildContext context, String title, String description) async {
    if (isEditing) {
      await databaseReference.collection("habits")
          .document(this.id)
          .updateData({
            'title': title,
            'description': description
          });
    } else {
      await databaseReference.collection("habits")
          .add({
        'title': title,
        'description': description
      });
    }

    Navigator.pop(context);
  }

  void onDelete(BuildContext context) async {
    await databaseReference.collection("habits")
      .document(this.id)
      .delete();

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
          AppLocalizations.of(context).translate(isEditing ? 'EDIT_HABIT' : 'NEW_HABIT'),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSave(context, _title, _description);
              }
            },
            child: Text(AppLocalizations.of(context).translate(isEditing ? 'SAVE' : 'ADD').toUpperCase()),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.habit.title : '',
                autofocus: !isEditing,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate('TITLE'),
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? "This is required"
                      : null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: isEditing ? widget.habit.description : '',
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate('DESCRIPTION'),
                ),
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),
              isEditing ?
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        widget.onDelete(context);
                      },
                      child: Text(AppLocalizations.of(context).translate('DELETE')),
                    ),
                  ) :
                new Container(width: 0, height: 0)
            ],
          ),
        ),
      ),
    );
  }

}