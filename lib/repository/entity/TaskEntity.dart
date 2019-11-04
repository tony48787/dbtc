import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String title;
  final String description;

  const TaskEntity(this.title, this.description);

  @override
  List<Object> get props => [title, description];

  @override
  String toString() {
    return 'TaskEntity { title: $title, description: $description }';
  }

  Map<String, Object> toDocument() {
    return {
      'title': title,
      'description': description
    };
  }

  static TaskEntity fromSnapshot(DocumentSnapshot snapshot) {
    return TaskEntity (
        snapshot.data['title'],
        snapshot.data['description']
    );
  }
}