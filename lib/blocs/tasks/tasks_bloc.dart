

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dbtc/blocs/tasks/tasks.dart';
import 'package:dbtc/repository/TasksRepository.dart';
import 'package:flutter/foundation.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _tasksRepository;
  StreamSubscription _tasksSubscription;

  TasksBloc({@required TasksRepository tasksRepository})
    : assert (tasksRepository != null),
        _tasksRepository = tasksRepository;

  @override
  TasksState get initialState => TasksLoadingState();

  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if (event is LoadTasks) {
      yield* _mapLoadTasksToState();
    } else if (event is TasksUpdated) {
      yield* _mapTasksUpdatedToState(event);
    }
  }

  Stream<TasksState> _mapLoadTasksToState() async* {
    _tasksSubscription?.cancel();
    _tasksSubscription = _tasksRepository.tasks().listen(
        (tasks) => add(TasksUpdated(tasks))
    );
  }

  Stream<TasksState> _mapTasksUpdatedToState(TasksUpdated event) async* {
    yield TasksLoadedState(event.tasks);
  }

  @override
  void close() {
    _tasksSubscription?.cancel();
    super.close();
  }
}