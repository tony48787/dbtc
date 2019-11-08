import 'package:dbtc/localizations/app_localizations.dart';
import 'package:flutter/material.dart';

class AlertDialogAction {
  String titleKey;
  VoidCallback onPressed;

  AlertDialogAction({ @required this.titleKey, this.onPressed });
}

class SimpleAlertDialog extends StatelessWidget {

  final String titleKey;
  final String contentKey;
  final List<AlertDialogAction> actions;

  SimpleAlertDialog({ @required this.titleKey, @required this.contentKey, @required this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate(titleKey)),
      content: Text(AppLocalizations.of(context).translate(contentKey)),
      actions: this.actions.map((action) {
        return FlatButton(
            child: Text(AppLocalizations.of(context).translate(action.titleKey).toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop();
              if (action.onPressed != null) action.onPressed();
            },
        );
      }).toList()
    );
  }
}