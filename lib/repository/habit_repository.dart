import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/habit.dart';

class HabitRepository {

  CollectionReference habitsCollection;
  String userId;

  HabitRepository(String userId) {
    this.userId = userId;
    this.habitsCollection = Firestore.instance
        .collection("users")
        .document(userId)
        .collection("habits");
  }

  Future<void> addNewHabit(Habit habit) {
    return habitsCollection.add(Habit.toDocument(habit));
  }

  Future<void> deleteHabit(String habitId) {
    return habitsCollection.document(habitId).delete();
  }

  Stream<List<Habit>> habits() {
    return habitsCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Habit.fromSnapshot(doc))
          .toList();
    });
  }

  Future<void> updateHabit(Habit habit) {
    return habitsCollection
        .document(habit.id)
        .updateData(Habit.toDocument(habit));
  }

}