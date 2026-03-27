import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(FirebaseFirestore.instance);
});

class CustomerRepository {
  final FirebaseFirestore _firestore;

  CustomerRepository(this._firestore);

  // Fetch all builders (Real-time stream)
  Stream<List<Map<String, dynamic>>> getBuildersStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'builder')
    // In a real app, you might want to filter by 'isVerified' too
    // .where('isVerified', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}