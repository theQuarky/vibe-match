import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static int createdAtThreshold = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Stream<QuerySnapshot> getChatStream(String userId) {
    _firestore.clearPersistence();
    createdAtThreshold = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _firestore
        .collection('chats-v2')
        .where('users', arrayContains: userId)
        .snapshots();
  }

  Stream<DocumentSnapshot> getFriendsStream(String userId) {
    print('loading friends from $userId user');
    return _firestore.collection('friends').doc(userId).snapshots();
  }
}
