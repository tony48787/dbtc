import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignupEvent extends Equatable {}

class FirstNameChanged extends SignupEvent {
  final String firstName;

  FirstNameChanged({@required this.firstName});

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName :$firstName }';
}

class LastNameChanged extends SignupEvent {
  final String lastName;

  LastNameChanged({@required this.lastName});

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { lastName :$lastName }';
}

class EmailChanged extends SignupEvent {
  final String email;

  EmailChanged({@required this.email});
  
  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends SignupEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Submitted({@required this.firstName, @required this.lastName, @required this.email, @required this.password});

  @override
  List<Object> get props => [firstName, lastName, email, password];

  @override
  String toString() {
    return 'Submitted { firstName: $firstName, lastName: $lastName, email: $email, password: $password }';
  }
}