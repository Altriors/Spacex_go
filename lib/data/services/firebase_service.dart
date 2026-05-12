import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth Methods
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Firestore Methods
  Future<void> createUserDocument(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> addFavoriteLaunch(String uid, String launchId) async {
    await _firestore.collection('users').doc(uid).update({
      'favoriteLaunches': FieldValue.arrayUnion([launchId])
    });
  }

  Future<void> removeFavoriteLaunch(String uid, String launchId) async {
    await _firestore.collection('users').doc(uid).update({
      'favoriteLaunches': FieldValue.arrayRemove([launchId])
    });
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
      (doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null,
    );
  }
}