import 'package:dbtc/blocs/tasks/tasks.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/repository/TasksRepository.dart';
import 'package:dbtc/screens/main_screen.dart';
import 'package:dbtc/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          builder: (context) => ThemeBloc(),
        ),
        BlocProvider<TasksBloc>(
          builder: (context) => TasksBloc(tasksRepository: FirebaseTasksRepository())
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      )
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).translate('APP_TITLE'),
      theme: appThemeData[state.appTheme],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      home: MainScreen(),
    );
  }

}



