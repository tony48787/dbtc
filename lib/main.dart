import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/blocs/user/user.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/repository/habit_repository.dart';
import 'package:dbtc/repository/user_repository.dart';
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
        BlocProvider<UserBloc>(
          builder: (context) => UserBloc(userRepository: UserRepository()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState themeState) {
    BlocProvider.of<UserBloc>(context).add(LoadUser("uiIb0swwBbF2gcI0DrsO"));

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) => _buildWithUser(context, themeState, userState)
    );
  }

  Widget _buildWithUser(BuildContext context, ThemeState themeState, UserState userState) {
    return BlocProvider<HabitBloc>(
      builder: (context) => HabitBloc(habitRepository: HabitRepository("uiIb0swwBbF2gcI0DrsO")),
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).translate('APP_TITLE'),
        theme: appThemeData[themeState.appTheme],
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
      ),
    );
  }

}



