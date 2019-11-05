import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dbtc/blocs/theme/theme_event.dart';
import 'package:dbtc/blocs/theme/theme_state.dart';
import 'package:dbtc/ui/app_theme.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {

  @override
  ThemeState get initialState => ThemeState(AppTheme.LIGHT);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeChanged) {
      yield ThemeState(state.appTheme == AppTheme.LIGHT ? AppTheme.DARK : AppTheme.LIGHT);
    }
  }

}