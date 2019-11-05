import 'package:dbtc/models/Task.dart';

abstract class TasksEvent {}

class LoadTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final Task task;

  AddTask(this.task);

  @override
  String toString() => 'AddTask { task: $task }';
}

class UpdateTask extends TasksEvent {
  final Task updatedTask;

  UpdateTask(this.updatedTask);

  @override
  String toString() => 'UpdateTask { updatedTask: $updatedTask }';
}

class TasksUpdated extends TasksEvent {
  final List<Task> tasks;

  TasksUpdated(this.tasks);
}