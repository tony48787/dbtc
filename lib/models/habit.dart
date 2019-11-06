import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final Map<String, bool> completedAtDate;

  const Habit(this.id, this.title, this.description, this.completedAtDate);

  @override
  String toString() {
    return 'Habit { id: $id, title: $title, description: $description, completedAtDate: $completedAtDate }';
  }

  Habit copyWith({ String id, String title, String description, Map<String, bool> completedAtDate }) {
    return Habit(
      id ?? this.id,
      title ?? this.title,
      description ?? this.description,
      completedAtDate ?? this.completedAtDate,
    );
  }

  static Habit fromSnapshot(DocumentSnapshot snapshot) {
    return Habit (
      snapshot.documentID,
      snapshot.data['title'],
      snapshot.data['description'],
      Map<String, bool>.from(snapshot.data['completedAtDate']),
    );
  }

  static Map<String, Object> toDocument(Habit habit) {
    return {
      'title': habit.title,
      'description': habit.description,
      'completedAtDate': habit.completedAtDate,
    };
  }

}