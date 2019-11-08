import 'package:dbtc/blocs/auth/auth.dart';
import 'package:dbtc/blocs/theme/theme.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/models/user.dart';
import 'package:dbtc/screens/signup_screen.dart';
import 'package:dbtc/widgets/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsSubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = (BlocProvider.of<AuthBloc>(context).state as Authenticated).user;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.brightness_medium),
              title: Text(AppLocalizations.of(context).translate('DARK_THEME')),
              onTap: () {
                BlocProvider.of<ThemeBloc>(context).add(ThemeChanged());
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text(AppLocalizations.of(context).translate('NOTIFICATION_TIME')),
              onTap: () {
                showNotificationDialog(context);
              },
            ),
            user.isAnonymous ?
            ListTile(
              leading: Icon(Icons.cached),
              title: Text(AppLocalizations.of(context).translate('CONVERT_GUEST_ACCOUNT')),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SignupScreen();
                  }),
                );
              },
            ) : Container(width: 0, height: 0),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(AppLocalizations.of(context).translate('LOGOUT')),
              onTap: () {
                showDialog(context: context, builder: (context) => SimpleAlertDialog(
                  titleKey: 'LOGOUT',
                  contentKey: user.isAnonymous ? 'LOGOUT_CONFIRMATION_GUEST' : 'LOGOUT_CONFIRMATION',
                  actions: [
                    AlertDialogAction(titleKey: 'CANCEL'),
                    AlertDialogAction(
                      titleKey: 'LOGOUT',
                      onPressed: () => BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
                    )
                  ],
                ));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showNotificationDialog(BuildContext parentContext) async {
    DateTime _dateTime = DateTime.now();

    return showDialog<void>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(AppLocalizations.of(context).translate('NOTIFICATION_TIME'))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                timePickerWidget(context, (DateTime newDateTime) {
                  _dateTime = newDateTime;
                })
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('SAVE')),
              onPressed: () {
                Navigator.of(context).pop();

//                _showNotificationWithoutSound();
              },
            ),
          ],
        );
      },
    );
  }

  Widget timePickerWidget(BuildContext context, _onDateTimeChanged) {
    final theme = CupertinoTheme.of(context);

    return CupertinoTheme(
      data: theme.copyWith(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height / 6,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: _onDateTimeChanged,
          use24hFormat: true,
          minuteInterval: 1,
        ),
      )
      ,
    );
  }
}
