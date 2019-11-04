import 'package:dbtc/repository/entity/TaskEntity.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String description;

  const Task(this.title, this.description);

  @override
  List<Object> get props => [title, description];

  @override
  String toString() {
    return 'Task { title: $title, description: $description }';
  }

  TaskEntity toEntity() {
    return TaskEntity(title, description);
  }

  static Task fromEntity(TaskEntity entity) {
    return Task (
      entity.title,
      entity.description
    );
  }
}