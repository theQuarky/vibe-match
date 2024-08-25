import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoto/services/serverless_service.dart';
import 'package:yoto/services/socket_service.dart';
import 'package:yoto/services/firestore_service.dart';

part 'match_store.g.dart';

class MatchStore = _MatchStore with _$MatchStore;

abstract class _MatchStore with Store {
  final ServerlessService _serverlessService;
  final FirestoreService _firestoreService;
  final SocketService _socketService;

  _MatchStore(
      this._socketService, this._serverlessService, this._firestoreService) {
    _initSocketListeners();
  }

  @observable
  bool isInQueue = false;

  @observable
  bool isSearching = false;

  @observable
  bool isChatEnded = false;

  @observable
  bool areFriendsNow = false;

  @observable
  DateTime? lastListenStartTime;

  @observable
  StreamSubscription<QuerySnapshot>? _matchListener;

  @observable
  Map<String, dynamic>? currentMatch;

  void _initSocketListeners() {
    _socketService
      ..on('chat_ended', _handleChatEnded)
      ..on('friend_request_accepted', _handleFriendRequestAccepted);
  }

  @action
  void setInQueue(bool value) => isInQueue = value;

  @action
  void setSearching(bool value) {
    isSearching = value;
    if (!value) stopListeningForMatches();
  }

  @action
  void resetMatchState() {
    isChatEnded = false;
    areFriendsNow = false;
  }

  @action
  Future<void> addToMatchQueue(Map<String, dynamic> userData) async {
    await _serverlessService.addToMatchQueue(userData);
    setInQueue(true);
  }

  @action
  Future<void> removeFromMatchQueue() async {
    await _serverlessService.removeFromMatchQueue();
    setInQueue(false);
  }

  @action
  void startListeningForMatches(
      String userId, Function(String, String) onMatchFound) {
    stopListeningForMatches();
    resetMatchState();
    lastListenStartTime = DateTime.now();

    _matchListener = _firestoreService.getChatStream(userId).listen(
          (snapshot) => _processSnapshot(snapshot, userId, onMatchFound),
          onError: (error) => print("Error in match listener: $error"),
        );
  }

  @action
  void stopListeningForMatches() {
    _matchListener?.cancel();
    _matchListener = null;
    lastListenStartTime = null;
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
      final users = List<String>.from(data['users'] ?? []);
      if (users.contains(userId)) {
        final otherUserId = users.firstWhere((id) => id != userId, orElse: () => '');
        if (otherUserId.isNotEmpty) {
          onMatchFound(doc.id, otherUserId);
        }
      }
    }
  }

  @action
  void endChat(String chatId, String userId) {
    _socketService.emit('end_chat', {'chatId': chatId, 'userId': userId});
  }

  @action
  void sendFriendRequest(String userId, String chatId) {
    _socketService.emit('add_friend', {'userId': userId, 'chatId': chatId});
  }

  @action
  void _handleChatEnded(dynamic data) {
    isChatEnded = true;
    // You might want to perform additional actions here, like updating UI
  }

  @action
  void _handleFriendRequestAccepted(dynamic data) {
    areFriendsNow = true;
    // You might want to perform additional actions here, like updating UI
    print('Friend request accepted for chat ${data['chatId']}');
  }

  @action
  Future<void> convertToPermanent(String anonymousChatId, String permanentChatId) async {
    _socketService.emit('convert_to_permanent', {
      'anonymousChatId': anonymousChatId,
      'permanentChatId': permanentChatId
    });
  }

  void dispose() {
    stopListeningForMatches();
    _socketService
      ..off('chat_ended')
      ..off('friend_request_accepted');
  }
}