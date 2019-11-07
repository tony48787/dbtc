import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/habit.dart';

class HabitRepository {

  CollectionReference habitsCollection(String userId) {
    return Firestore.instance.collection("users").document(userId).collection("habits");
  }

  Future<void> addNewHabit(String userId, Habit habit) {
    return habitsCollection(userId).add(Habit.toDocument(habit, isAdd: true));
  }

  Future<void> deleteHabit(String userId, String habitId) {
    return habitsCollection(userId).document(habitId).delete();
  }

  Stream<List<Habit>> habits(String userId) {
    return habitsCollection(userId).snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Habit.fromSnapshot(doc))
          .toList();
    });
  }

  Future<void> updateHabit(String userId, Habit habit) {
    return habitsCollection(userId)
        .document(habit.id)
        .updateData(Habit.toDocument(habit));
  }

}