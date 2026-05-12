import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/firebase_service.dart';
import '../data/models/user_model.dart';

class AuthProviderApp extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = true;
  String? _errorMessage;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProviderApp() {
    _initAuth();
  }

  void _initAuth() {
    _firebaseService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userModel = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _userModel = await _firebaseService.getUserDocument(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firebaseService.signInWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String? displayName) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential credential = await _firebaseService.registerWithEmail(email, password);
      
      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      await _firebaseService.createUserDocument(newUser);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> addFavorite(String launchId) async {
    if (_user != null) {
      await _firebaseService.addFavoriteLaunch(_user!.uid, launchId);
      await _loadUserData(_user!.uid);
    }
  }

  Future<void> removeFavorite(String launchId) async {
    if (_user != null) {
      await _firebaseService.removeFavoriteLaunch(_user!.uid, launchId);
      await _loadUserData(_user!.uid);
    }
  }

  bool isFavorite(String launchId) {
    return _userModel?.favoriteLaunches.contains(launchId) ?? false;
  }
}