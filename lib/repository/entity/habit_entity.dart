import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  final String documentId;
  final String title;
  final String description;
  final List<dynamic> completions;
  final int streak;

  const HabitEntity(this.documentId, this.title, this.description, this.completions, this.streak);

  @override
  List<Object> get props => [title, description];

  @override
  String toString() {
    return 'HabitEntity { documentId: $documentId, title: $title, description: $description, completions: $completions, streak: $streak}';
  }

  Map<String, Object> toDocument() {
    return {
      'title': title,
      'description': description,
      'completions': completions,
      'streak': streak,
    };
  }

  static HabitEntity fromSnapshot(DocumentSnapshot snapshot) {
    return HabitEntity (
        snapshot.documentID,
        snapshot.data['title'],
        snapshot.data['description'],
        snapshot.data['completions'],
        snapshot.data['streak'],
    );
  }
}