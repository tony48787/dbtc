import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final List<dynamic> completions;
  final int streak;

  const Habit(this.id, this.title, this.description, this.completions, this.streak);

  @override
  String toString() {
    return 'Habit { id: $id, title: $title, description: $description, completions: $completions, streak: $streak }';
  }

  Habit copyWith({String id, String title, String description, List<String> completions, int streak}) {
    return Habit(
      id ?? this.id,
      title ?? this.title,
      description ?? this.description,
      completions ?? this.completions,
      streak ?? this.streak,
    );
  }

  static Habit fromSnapshot(DocumentSnapshot snapshot) {
    return Habit (
      snapshot.documentID,
      snapshot.data['title'],
      snapshot.data['description'],
      snapshot.data['completions'],
      snapshot.data['streak'],
    );
  }

  static Map<String, Object> toDocument(Habit habit) {
    return {
      'title': habit.title,
      'description': habit.description,
      'completions': habit.completions,
      'streak': habit.streak,
    };
  }

}