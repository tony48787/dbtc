import 'package:dbtc/repository/entity/TaskEntity.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<dynamic> completions;
  final int streak;

  const Task(this.id, this.title, this.description, this.completions, this.streak);

  @override
  List<Object> get props => [title, description];

  @override
  String toString() {
    return 'Task { id: $id, title: $title, description: $description, completions: $completions, streak: $streak }';
  }

  TaskEntity toEntity() {
    return TaskEntity(id, title, description, completions, streak);
  }

  static Task fromEntity(TaskEntity entity) {
    return Task (
      entity.documentId,
      entity.title,
      entity.description,
      entity.completions,
      entity.streak
    );
  }

  Task copyWith({String id, String title, String description, List<String> completions, int streak}) {
    return Task(
      id ?? this.id,
      title ?? this.title,
      description ?? this.description,
      completions ?? this.completions,
      streak ?? this.streak,
    );
  }
}