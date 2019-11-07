import 'package:dbtc/models/user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);

  @override
  String toString() => 'Authenticated { user: $user }';
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';
}