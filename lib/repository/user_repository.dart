import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/user.dart';

class UserRepository {

  final usersCollection = Firestore.instance.collection('users');

  Stream<User> loadUser(String id) {
    return usersCollection.document(id).get().asStream().map((snapshot) {
      return User.fromSnapshot(snapshot);
    });
  }

  Future<void> updateUser(User user) {
    return usersCollection
        .document(user.id)
        .updateData(User.toDocument(user));
  }

}