import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final Map<String, bool> completedAtDate;
  DateTime createdAt;
  DateTime updatedAt;

  Habit(this.id, this.title, this.description, this.completedAtDate, { this.createdAt, this.updatedAt });

  @override
  String toString() {
    return 'Habit { id: $id, title: $title, description: $description, completedAtDate: $completedAtDate }';
  }

  Habit copyWith({ String id, String title, String description, Map<String, bool> completedAtDate, DateTime createdAt, DateTime updatedAt }) {
    return Habit(
      id ?? this.id,
      title ?? this.title,
      description ?? this.description,
      completedAtDate ?? this.completedAtDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Habit fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;
    return Habit (
      snapshot.documentID,
      data['title'],
      data['description'],
      Map<String, bool>.from(data['completedAtDate']),
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );
  }

  static Map<String, Object> toDocument(Habit habit, { isAdd = false }) {
    Map<String, Object> document = {
      'title': habit.title,
      'description': habit.description,
      'completedAtDate': habit.completedAtDate,
      'updatedAt': DateTime.now()
    };
    if (isAdd) document['createdAt'] = DateTime.now();
    return document;
  }

}