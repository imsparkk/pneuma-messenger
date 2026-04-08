import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: trimmedQuery)
        .where('name', isLessThanOrEqualTo: '\$trimmedQuery\uf8ff')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
