import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoto/services/serverless_service.dart';

part 'match_store.g.dart';

class MatchStore = _MatchStore with _$MatchStore;

abstract class _MatchStore with Store {
  final ServerlessService _serverlessService = ServerlessService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @observable
  bool isInQueue = false;

  @observable
  StreamSubscription<QuerySnapshot>? _matchListener;

  @observable
  Map<String, dynamic>? currentMatch;

  @action
  void setInQueue(bool value) {
    isInQueue = value;
  }

  @action
  Future<void> addToMatchQueue(Map<String, dynamic> userData) async {
    try {
      await _serverlessService.addToMatchQueue(userData);
    } catch (e) {
      print('Error adding to match queue: $e');
      rethrow;
    }
  }

  @action
  Future<void> removeFromMatchQueue() async {
    try {
      await _serverlessService.removeFromMatchQueue();
    } catch (e) {
      print('Error removing from match queue: $e');
      rethrow;
    }
  }

  @action
  void startListeningForMatches(String userId, Function onMatchFound) {
    _matchListener = _firestore
        .collection('chats-v2')
        .where('users', arrayContains: userId)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _handleNewMatch(change.doc, userId, onMatchFound);
        }
      }
    });
  }

  @action
  void _handleNewMatch(
      DocumentSnapshot doc, String userId, Function onMatchFound) {
    print('New match found: ${doc.id}');
    Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;
    if (chatData['isPermanent'] != true) {
      String otherUserId =
          (chatData['users'] as List<dynamic>).firstWhere((id) => id != userId);
      currentMatch = {
        'chatId': doc.id,
        'otherUserId': otherUserId,
        ...chatData,
      };
      onMatchFound();
    }
  }

  @action
  void stopListeningForMatches() {
    _matchListener?.cancel();
    _matchListener = null;
  }
}
