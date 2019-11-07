import 'package:dbtc/blocs/auth/auth.dart';
import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/repository/habit_repository.dart';
import 'package:dbtc/repository/user_repository.dart';
import 'package:dbtc/screens/login_screen.dart';
import 'package:dbtc/screens/main_screen.dart';
import 'package:dbtc/screens/splash_screen.dart';
import 'package:dbtc/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/theme/theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          builder: (context) => ThemeBloc(),
        ),
        BlocProvider<AuthBloc>(
          builder: (context) => AuthBloc(userRepository: UserRepository()),
        ),
        BlocProvider<HabitBloc>(
          builder: (context) => HabitBloc(habitRepository: HabitRepository()),
        )
      ],
      child: RepositoryProvider(
        builder: (context) => UserRepository(),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: _buildWithTheme,
        ),
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    BlocProvider.of<AuthBloc>(context).add(AppStarted());

    return  MaterialApp(
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
      home: BlocBuilder<AuthBloc, AuthState>(
          builder: _buildWithAuth
      ),
    );
  }

  Widget _buildWithAuth(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      return MainScreen();
    } else if (state is Unauthenticated) {
      return LoginScreen();
    } else {
      return SplashScreen();
    }
  }

}



