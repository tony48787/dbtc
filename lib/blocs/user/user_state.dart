import 'package:dbtc/models/user.dart';

abstract class UserState {
  const UserState();
}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final User user;
  const UserLoadedState(this.user);
}

class UserNotLoadedState extends UserState {}