import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/Task.dart';
import 'package:dbtc/repository/entity/TaskEntity.dart';

abstract class TasksRepository {
  Future<void> addNewTask(Task task);

  Future<void> deleteTask(Task task);

  Stream<List<Task>> tasks();

  Future<void> updateTask(Task task);
}

class FirebaseTasksRepository extends TasksRepository {
  final tasksCollection = Firestore.instance.collection("tasks");

  @override
  Future<void> addNewTask(Task task) {
    return tasksCollection.add(task.toEntity().toDocument());
  }

  @override
  Future<void> deleteTask(Task task) {
    // TODO: implement deleteTask
    return null;
  }

  @override
  Stream<List<Task>> tasks() {
    return tasksCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Task.fromEntity(TaskEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateTask(Task task) {
    return tasksCollection
        .document(task.id)
        .updateData(task.toEntity().toDocument());
  }

}