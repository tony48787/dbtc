import 'package:bloc/bloc.dart';
import 'package:dbtc/blocs/user/user_event.dart';
import 'package:dbtc/blocs/user/user_state.dart';
import 'package:dbtc/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  final UserRepository _userRepository;

  UserBloc({@required UserRepository userRepository})
      : assert (userRepository != null),
          _userRepository = userRepository;

  @override
  UserState get initialState => UserLoadingState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch(event.runtimeType) {
      case LoadUser: {
        yield* _mapLoadUserToState(event);
      }
      break;
    }
  }

  Stream<UserState> _mapLoadUserToState(LoadUser event) {
    return _userRepository.loadUser(event.id).map((user) => UserLoadedState(user));
  }

}