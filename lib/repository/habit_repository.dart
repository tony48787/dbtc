import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/habit.dart';
import 'package:dbtc/repository/entity/habit_entity.dart';

abstract class HabitRepository {
  Future<void> addNewHabit(Habit habit);

  Future<void> deleteHabit(Habit habit);

  Stream<List<Habit>> habits();

  Future<void> updateHabit(Habit habit);
}

class FirebaseHabitRepository extends HabitRepository {
  final habitsCollection = Firestore.instance.collection("tasks");

  @override
  Future<void> addNewHabit(Habit habit) {
    return habitsCollection.add(habit.toEntity().toDocument());
  }

  @override
  Future<void> deleteHabit(Habit habit) {
    // TODO: implement deleteHabit
    return null;
  }

  @override
  Stream<List<Habit>> habits() {
    return habitsCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Habit.fromEntity(HabitEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateHabit(Habit habit) {
    return habitsCollection
        .document(habit.id)
        .updateData(habit.toEntity().toDocument());
  }

}