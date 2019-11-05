import 'package:dbtc/models/Task.dart';

abstract class TasksState {
  const TasksState();
}

class TasksLoadingState extends TasksState {}

class TasksLoadedState extends TasksState {
  final List<Task> tasks;

  const TasksLoadedState([this.tasks = const []]);

  @override
  String toString() => 'TasksLoaded { tasks: $tasks }';
}

class TasksNotLoadedState extends TasksState {}