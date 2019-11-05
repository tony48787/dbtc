import 'package:dbtc/repository/entity/habit_entity.dart';
import 'package:equatable/equatable.dart';

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

  HabitEntity toEntity() {
    return HabitEntity(id, title, description, completions, streak);
  }

  static Habit fromEntity(HabitEntity entity) {
    return Habit (
      entity.documentId,
      entity.title,
      entity.description,
      entity.completions,
      entity.streak
    );
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
}