import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtc/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {

  final _usersCollection = Firestore.instance.collection('users');
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResult> signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future<AuthResult> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  AuthCredential getCredential({String email, String password}) {
    return EmailAuthProvider.getCredential(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await getFirebaseUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getFirebaseUser() async {
    return _firebaseAuth.currentUser();
  }

  Future<User> getUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    DocumentSnapshot snapshot = await _usersCollection.document(firebaseUser.uid).get();
    return User.fromSnapshot(snapshot);
  }

  Future<void> updateUser(User user) {
    return _usersCollection
        .document(user.id)
        .updateData(User.toDocument(user));
  }

  Future<void> setUser(User user) {
    return _usersCollection
        .document(user.id)
        .setData(User.toDocument(user, isAdd: true));
  }

}