import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Match-related operations
  Stream<QuerySnapshot> getChatStream(String userId) {
    return _firestore
        .collection('chats-v2')
        .where('users', arrayContains: userId)
        .snapshots();
  }

  // Friend-related operations
  Stream<DocumentSnapshot> getFriendsStream(String userId) {
    print('loading friends from $userId user');
    return _firestore.collection('friends').doc(userId).snapshots();
  }
}
