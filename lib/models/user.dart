import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  DateTime createdAt;
  DateTime updatedAt;
  bool isAnonymous;

  User(this.id, this.firstName, this.lastName, { this.createdAt, this.updatedAt, this.isAnonymous = false });

  @override
  String toString() {
    return 'User { id: $id, firstName: $firstName, lastName: $lastName }';
  }

  User copyWith({ String id, String firstName, String lastName, DateTime createdAt, DateTime updatedAt, bool isAnonymous }) {
    return User(
      id ?? this.id,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;
    return User (
      snapshot.documentID,
      data['firstName'],
      data['lastName'],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      isAnonymous: data['isAnonymous'],
    );
  }

  static Map<String, Object> toDocument(User user, { isAdd = false }) {
    Map<String, Object> document = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'updatedAt': DateTime.now(),
      'isAnonymous': user.isAnonymous,
    };

    if (isAdd) document['createdAt'] = DateTime.now();
    return document;
  }
}