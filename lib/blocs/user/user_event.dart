import 'package:dbtc/models/user.dart';

abstract class UserEvent {}

// ACTIONS
class LoadUser extends UserEvent {
  final String id;
  LoadUser(this.id);
}