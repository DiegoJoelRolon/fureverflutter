import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/PetPost.dart';
import '../models/AdoptionRequest.dart';
import '../notificacion/NotificationService.dart';
import '../location/LocationHelper.dart';

class PetProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<PetPost> _pets = [];
  List<AdoptionRequest> _pendingRequests = [];
  String _searchQuery = '';
  String _speciesFilter = 'Todas';
  String _genderFilter = 'Todos';
  String _sizeFilter = 'Todos';
  String _ageFilter = 'Todos';
  String get searchQuery => _searchQuery;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PetPost> get pets => _pets;
  List<AdoptionRequest> get pendingRequests => _pendingRequests;

  List<PetPost> get recentPets =>
      _pets.where((p) => p.adoptedStatus == 'Disponible').take(10).toList();

  List<PetPost> get dogs => _pets
      .where((p) => p.species == 'Perro' && p.adoptedStatus == 'Disponible')
      .toList();

  List<PetPost> get cats => _pets
      .where((p) => p.species == 'Gato' && p.adoptedStatus == 'Disponible')
      .toList();

  List<PetPost> get puppies => _pets
      .where((p) => p.ageGroup == 'Cachorro' && p.adoptedStatus == 'Disponible')
      .toList();

  List<PetPost> get others => _pets
      .where((p) => p.species == 'Otro' && p.adoptedStatus == 'Disponible')
      .toList();

  List<PetPost> get filteredPets {
    return _pets.where((pet) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          pet.name.toLowerCase().contains(q) ||
          pet.city.toLowerCase().contains(q) ||
          pet.breed.toLowerCase().contains(q);
      final matchesSpecies =
          _speciesFilter == 'Todas' || pet.species == _speciesFilter;
      final matchesGender =
          _genderFilter == 'Todos' || pet.gender == _genderFilter;
      final matchesSize = _sizeFilter == 'Todos' || pet.size == _sizeFilter;
      final matchesAge = _ageFilter == 'Todos' || pet.ageGroup == _ageFilter;
      return matchesSearch &&
          matchesSpecies &&
          matchesGender &&
          matchesSize &&
          matchesAge;
    }).toList();
  }

  void onSearchChanged(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void onSpeciesChanged(String s) {
    _speciesFilter = s;
    notifyListeners();
  }

  void onGenderChanged(String g) {
    _genderFilter = g;
    notifyListeners();
  }

  void onSizeChanged(String s) {
    _sizeFilter = s;
    notifyListeners();
  }

  void onAgeChanged(String a) {
    _ageFilter = a;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _speciesFilter = 'Todas';
    _genderFilter = 'Todos';
    _sizeFilter = 'Todos';
    _ageFilter = 'Todos';
    notifyListeners();
  }

  void fetchPets() {
    _isLoading = true;
    notifyListeners();
    _db
        .collection('pets')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          _pets = snapshot.docs
              .map((doc) => PetPost.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          _isLoading = false;
          notifyListeners();
        });
  }

  void fetchPendingRequests() {
    final myEmail = _auth.currentUser?.email ?? '';

    _db
        .collection('adoptionRequests')
        .where('ownerId', isEqualTo: myEmail)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          for (final doc in snapshot.docChanges) {
            if (doc.type == DocumentChangeType.added) {
              final data = doc.doc.data();
              NotificationService.show(
                title: 'Nueva solicitud',
                body:
                    '${data?['requesterName']} quiere adoptar ${data?['petName']}',
              );
            }
          }

          _pendingRequests = snapshot.docs
              .map(
                (doc) =>
                    AdoptionRequest.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList();

          notifyListeners();
        });
  }

  Future<void> adoptPet(String petId) async {
    final adopterEmail = _auth.currentUser?.email ?? '';
    final adopterUid = _auth.currentUser?.uid ?? '';
    final doc = await _db.collection('users').doc(adopterUid).get();
    final phone = doc.data()?['phone'] ?? '';

    await _db.collection('pets').doc(petId).update({
      'adoptedStatus': 'Adoptado',
      'adopterEmail': adopterEmail,
      'adopterPhone': phone,
    });
  }

  Future<String> checkMyRequestStatus(String petId) async {
    final email = _auth.currentUser?.email ?? '';
    final snap = await _db
        .collection('adoptionRequests')
        .where('petId', isEqualTo: petId)
        .where('requesterId', isEqualTo: email)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return '';
    return snap.docs.first.data()['status'] ?? '';
  }

  Future<void> uploadPet({
    required String name,
    required String breed,
    required String description,
    required String city,
    required String species,
    required String gender,
    required String size,
    required String ageGroup,
    File? imageFile,
    double latitude = 0.0,
    double longitude = 0.0,
  }) async {
    final uid = _auth.currentUser?.uid ?? '';
    final email = _auth.currentUser?.email ?? '';

    String imageBase64 = '';
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      imageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    }

    final docRef = _db.collection('pets').doc();
    await docRef.set({
      'id': docRef.id,
      'name': name,
      'breed': breed,
      'description': description,
      'city': city,
      'species': species,
      'gender': gender,
      'size': size,
      'ageGroup': ageGroup,
      'imageUrl': imageBase64,
      'images': imageBase64.isNotEmpty ? [imageBase64] : [],
      'adoptedStatus': 'Disponible',
      'ownerId': email,
      'ownerUid': uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<void> sendAdoptionRequest(PetPost pet) async {
    final requesterEmail = _auth.currentUser?.email ?? '';
    final requesterUid = _auth.currentUser?.uid ?? '';
    final doc = await _db.collection('users').doc(requesterUid).get();
    final name = '${doc.data()?['name'] ?? ''} ${doc.data()?['lastname'] ?? ''}'
        .trim();

    final ref = _db.collection('adoptionRequests').doc();
    await ref.set({
      'id': ref.id,
      'petId': pet.id,
      'petName': pet.name,
      'petImageUrl': pet.imageUrl,
      'requesterId': requesterEmail,
      'requesterName': name.isEmpty ? requesterEmail : name,
      'ownerId': pet.ownerId,
      'status': 'pending',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> acceptRequest(AdoptionRequest request) async {
    final batch = _db.batch();
    batch.update(_db.collection('adoptionRequests').doc(request.id), {
      'status': 'accepted',
    });
    batch.update(_db.collection('pets').doc(request.petId), {
      'adoptedStatus': 'Adoptado',
      'adopterEmail': request.requesterId,
    });
    await batch.commit();
  }

  Future<void> rejectRequest(AdoptionRequest request) async {
    await _db.collection('adoptionRequests').doc(request.id).update({
      'status': 'rejected',
    });
  }

  Future<void> deletePet(String petId) async {
    await _db.collection('pets').doc(petId).delete();
  }

  Future<void> updatePet({
    required String petId,
    required String name,
    required String breed,
    required String description,
    required String city,
    required String species,
    required String gender,
    required String size,
    required String ageGroup,
  }) async {
    await _db.collection('pets').doc(petId).update({
      'name': name,
      'breed': breed,
      'description': description,
      'city': city,
      'species': species,
      'gender': gender,
      'size': size,
      'ageGroup': ageGroup,
    });
  }
}