import 'package:dbtc/blocs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsSubScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.brightness_medium),
          title: Text('Dark theme'),
          onTap: () {
            BlocProvider.of<ThemeBloc>(context).add(ThemeChanged());
          },
        ),
      ],
    );
  }

}