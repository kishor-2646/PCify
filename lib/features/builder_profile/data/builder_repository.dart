import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Storage
import 'package:flutter_riverpod/flutter_riverpod.dart';

final builderRepositoryProvider = Provider<BuilderRepository>((ref) {
  return BuilderRepository(
      FirebaseFirestore.instance,
      FirebaseAuth.instance,
      FirebaseStorage.instance // Inject Storage
  );
});

class BuilderRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  BuilderRepository(this._firestore, this._auth, this._storage);

  String? get currentUserId => _auth.currentUser?.uid;

  // --- Profile Logic ---
  Future<Map<String, dynamic>?> getBuilderProfile() async {
    final uid = currentUserId;
    if (uid == null) throw 'User not logged in';

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> updateBuilderProfile(Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) throw 'User not logged in';
    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  // --- Portfolio Logic ---

  Stream<List<Map<String, dynamic>>> getPortfolioStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('portfolio')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  // NEW: Upload Image to Firebase Storage
  Future<String> uploadImage(File file, String folder) async {
    final uid = currentUserId;
    if (uid == null) throw 'User not logged in';

    // Create a unique filename: users/{uid}/{folder}/{timestamp}.jpg
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference ref = _storage.ref().child('users/$uid/$folder/$fileName.jpg');

    // Upload
    final UploadTask task = ref.putFile(file);
    final TaskSnapshot snapshot = await task;

    // Get URL
    return await snapshot.ref.getDownloadURL();
  }

  // Updated Add Portfolio to accept image URL
  Future<void> addPortfolioItem({
    required String name,
    required String description,
    required String cost,
    required String imageUrl,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw 'User not logged in';

    await _firestore.collection('users').doc(uid).collection('portfolio').add({
      'name': name,
      'description': description,
      'cost': cost,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePortfolioItem(String itemId) async {
    final uid = currentUserId;
    if (uid == null) throw 'User not logged in';

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('portfolio')
        .doc(itemId)
        .delete();
  }
}