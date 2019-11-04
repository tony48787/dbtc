import 'package:dbtc/models/Task.dart';
import 'package:equatable/equatable.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksLoadingState extends TasksState {}

class TasksLoadedState extends TasksState {
  final List<Task> tasks;

  const TasksLoadedState([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() => 'TasksLoaded { tasks: $tasks }';
}

class TasksNotLoadedState extends TasksState {}