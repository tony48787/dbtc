import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String documentId;
  final String title;
  final String description;
  final List<dynamic> completions;
  final int streak;

  const TaskEntity(this.documentId, this.title, this.description, this.completions, this.streak);

  @override
  List<Object> get props => [title, description];

  @override
  String toString() {
    return 'TaskEntity { documentId: $documentId, title: $title, description: $description, completions: $completions, streak: $streak}';
  }

  Map<String, Object> toDocument() {
    return {
      'title': title,
      'description': description,
      'completions': completions,
      'streak': streak,
    };
  }

  static TaskEntity fromSnapshot(DocumentSnapshot snapshot) {
    return TaskEntity (
        snapshot.documentID,
        snapshot.data['title'],
        snapshot.data['description'],
        snapshot.data['completions'],
        snapshot.data['streak'],
    );
  }
}