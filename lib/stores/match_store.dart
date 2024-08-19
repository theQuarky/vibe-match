import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoto/services/serverless_service.dart';
import 'package:yoto/services/socket_service.dart';

part 'match_store.g.dart';

class MatchStore = _MatchStore with _$MatchStore;

abstract class _MatchStore with Store {
  final ServerlessService _serverlessService;
  final FirebaseFirestore _firestore;
  final SocketService _socketService;

  _MatchStore(this._socketService, this._serverlessService, this._firestore);

  @observable
  String? endedChatId;

  @observable
  bool isInQueue = false;

  @observable
  StreamSubscription<QuerySnapshot>? _matchListener;

  @observable
  Map<String, dynamic>? currentMatch;

  @observable
  bool isSearching = false;

  @observable
  DateTime? lastListenStartTime;

  @action
  void setInQueue(bool value) => isInQueue = value;

  @action
  Future<void> addToMatchQueue(Map<String, dynamic> userData) =>
      _serverlessService.addToMatchQueue(userData);

  @action
  Future<void> removeFromMatchQueue() =>
      _serverlessService.removeFromMatchQueue();

  @action
  void startListeningForMatches(
      String userId, Function(String, String) onMatchFound) {
    stopListeningForMatches();
    lastListenStartTime = DateTime.now();

    _matchListener = _firestore
        .collection('chats-v2')
        .where('users', arrayContains: userId)
        .where('createdAt',
            isGreaterThan: Timestamp.fromDate(lastListenStartTime!))
        .snapshots()
        .listen(
          (snapshot) => _processSnapshot(snapshot, userId, onMatchFound),
          onError: (error) => print("Error in match listener: $error"),
        );
  }

  void _processSnapshot(QuerySnapshot snapshot, String userId,
      Function(String, String) onMatchFound) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        _handleNewMatch(change.doc, userId, onMatchFound);
      }
    }
  }

  void _handleNewMatch(DocumentSnapshot doc, String userId,
      Function(String, String) onMatchFound) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data != null && data['isPermanent'] != true) {
      final users = data['users'] as List<dynamic>?;
      if (users != null && users.contains(userId)) {
        final otherUserId =
            users.firstWhere((id) => id != userId, orElse: () => null);
        if (otherUserId != null) {
          onMatchFound(doc.id, otherUserId);
        }
      }
    }
  }

  @action
  void stopListeningForMatches() {
    _matchListener?.cancel();
    _matchListener = null;
    lastListenStartTime = null;
  }

  @action
  void setSearching(bool value) {
    isSearching = value;
    if (!value) stopListeningForMatches();
  }

  @action
  void listenForChatEnd(String chatId, Function(String) onChatEnded) {
    _socketService.on('chat_ended', (data) {
      if (data['chatId'] == chatId) {
        endedChatId = chatId;
        onChatEnded(chatId);
      }
    });
  }

  @action
  void stopListeningForChatEnd() => _socketService.off('chat_ended');

  void dispose() {
    stopListeningForMatches();
    stopListeningForChatEnd();
  }
}
