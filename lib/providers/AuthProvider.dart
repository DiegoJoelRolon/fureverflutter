import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/UserFlutter.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserFlutter? _currentUser;
  UserFlutter? get currentUser => _currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _fetchUserProfile(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      _currentUser = UserFlutter.fromJson(doc.data()!);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String petId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _currentUser == null) return;

    final favs = List<String>.from(_currentUser!.favorites);
    if (favs.contains(petId)) {
      favs.remove(petId);
    } else {
      favs.add(petId);
    }

    _currentUser = _currentUser!.copyWith(favorites: favs);
    notifyListeners();

    await _db.collection('users').doc(uid).update({'favorites': favs});
  }

  Future<void> addAllToFavorites(List<String> petIds) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _currentUser == null) return;

    final favs = {..._currentUser!.favorites, ...petIds}.toList();
    _currentUser = _currentUser!.copyWith(favorites: favs);
    notifyListeners();

    await _db.collection('users').doc(uid).update({'favorites': favs});
  }

  Future<void> savePreferences({
    required String prefSpecies,
    required String prefSize,
    required String prefAge,
    required String prefGender,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _currentUser = _currentUser!.copyWith(
      prefSpecies: prefSpecies,
      prefSize: prefSize,
      prefAge: prefAge,
      prefGender: prefGender,
      hasCompletedOnboarding: true,
    );
    notifyListeners();

    await _db.collection('users').doc(uid).update({
      'prefSpecies': prefSpecies,
      'prefSize': prefSize,
      'prefAge': prefAge,
      'prefGender': prefGender,
      'hasCompletedOnboarding': true,
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}