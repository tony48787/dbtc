import 'package:dbtc/blocs/auth/auth.dart';
import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/habit.dart';
import 'package:dbtc/widgets/full_width_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSaveCallback = Function(String habit, String note);

class AddEditScreen extends StatefulWidget {

  final Habit habit;

  AddEditScreen({ this.habit });

  @override
  _AddEditScreenState createState() => _AddEditScreenState(habit);

}

class _AddEditScreenState extends State<AddEditScreen> {

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Habit habit;

  String _title;
  String _description;

  bool get isEditing => habit != null;
  String get userId => (BlocProvider.of<AuthBloc>(context).state as Authenticated).user.id;

  _AddEditScreenState(this.habit);

  void onSave(String title, String description) {
    if (isEditing) {
      Habit newHabit = habit.copyWith(title: title, description: description);
      BlocProvider.of<HabitBloc>(context).add(UpdateHabit(userId, newHabit));
    } else {
      Habit newHabit = Habit(null, title, description, Map());
      BlocProvider.of<HabitBloc>(context).add(AddHabit(userId, newHabit));
    }

    Navigator.pop(context);
  }

  void onDelete() {
    BlocProvider.of<HabitBloc>(context).add(DeleteHabit(userId, habit.id));

    Navigator.pop(context);
  }

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
                onSave(_title, _description);
              }
            },
            child: Text(AppLocalizations.of(context).translate(isEditing ? 'SAVE' : 'ADD').toUpperCase()),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
                      ? AppLocalizations.of(context).translate('THIS_IS_REQUIRED')
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
                  FullWidthRaisedButton(
                    onPressed: onDelete,
                    text: AppLocalizations.of(context).translate('DELETE'),
                  ) : Container(width: 0, height: 0)
            ],
          ),
        ),
      ),
    );
  }

}