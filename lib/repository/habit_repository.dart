import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/habit.dart';

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
    return habitsCollection.add(Habit.toDocument(habit));
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
          .map((doc) => Habit.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Future<void> updateHabit(Habit habit) {
    return habitsCollection
        .document(habit.id)
        .updateData(Habit.toDocument(habit));
  }

}