import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dbtc/models/user.dart';
import 'package:dbtc/repository/user_repository.dart';
import 'package:dbtc/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;

  SignupBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SignupState get initialState => SignupState.empty();

  @override
  Stream<SignupState> transformEvents(
      Stream<SignupEvent> events,
      Stream<SignupState> Function(SignupEvent event) next,
      ) {
    final observableStream = events as Observable<SignupEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! FirstNameChanged
          && event is! LastNameChanged
          && event is! EmailChanged
          && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is FirstNameChanged
          || event is LastNameChanged
          || event is EmailChanged
          || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignupState> mapEventToState(
      SignupEvent event,
      ) async* {
    if (event is FirstNameChanged) {
      yield* _mapFirstNameChangedToState(event.firstName);
    } else if (event is LastNameChanged) {
      yield* _mapLastNameChangedToState(event.lastName);
    } else if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.firstName, event.lastName, event.email, event.password);
    }
  }

  Stream<SignupState> _mapFirstNameChangedToState(String firstName) async* {
    yield state.update(
      isFirstNameValid: firstName.isNotEmpty,
    );
  }

  Stream<SignupState> _mapLastNameChangedToState(String lastName) async* {
    yield state.update(
      isLastNameValid: lastName.isNotEmpty,
    );
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignupState> _mapFormSubmittedToState(
      String firstName,
      String lastName,
      String email,
      String password,
      ) async* {
    yield SignupState.loading();
    try {
      AuthResult authResult = await _userRepository.signUp(
        email: email,
        password: password,
      );
      await _userRepository.setUser(User(authResult.user.uid, firstName, lastName));
      yield SignupState.success();
    } catch (_) {
      yield SignupState.failure();
    }
  }
}