import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;

  User(this.id, this.firstName, this.lastName);

  static User fromSnapshot(DocumentSnapshot snapshot) {
    return User (
      snapshot.documentID,
      snapshot.data['firstName'],
      snapshot.data['lastName'],
    );
  }

  static Map<String, Object> toDocument(User user) {
    return {
      'firstName': user.firstName,
      'lastName': user.lastName,
    };
  }
}