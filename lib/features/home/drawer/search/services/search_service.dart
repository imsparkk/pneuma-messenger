import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: trimmedQuery)
          .where('name', isLessThanOrEqualTo: '$trimmedQuery\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => {
                ...doc.data(),
                'uid': doc.id,
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  

}
