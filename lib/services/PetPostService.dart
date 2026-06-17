import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fureverflutter/models/PetPost.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetPostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<PetPost>> getDogs() => getPostsBySpecies('Perro');
  Stream<List<PetPost>> getCats() => getPostsBySpecies('Gato');
  Stream<List<PetPost>> getOthers() => getPostsBySpecies('Otro');
  Future<void> createPetPost(PetPost petPost) async {
    final docRef = _firestore.collection('pet_posts').doc();

    final petPostFinal = petPost.copyWith(
      id: docRef.id,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
    );
    //Guarda en firestore
    await docRef.set(petPostFinal.toJson());
  }

  Stream<List<PetPost>> getPostsBySpecies(String species) {
    return getPosts().map(
      (posts) => posts.where((p) => p.species == species).toList(),
    );
  }

  Stream<List<PetPost>> getPosts() {
    return _firestore
        .collection('pet_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => PetPost.fromJson(d.data())).toList());
  }
}
