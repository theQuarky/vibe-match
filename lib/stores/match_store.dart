import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoto/services/serverless_service.dart';
import 'package:yoto/services/socket_service.dart';

part 'match_store.g.dart';

class MatchStore = _MatchStore with _$MatchStore;

abstract class _MatchStore with Store {
  // Dependencies
  final ServerlessService _serverlessService;
  final FirebaseFirestore _firestore;
  final SocketService _socketService;

  // Constructor
  _MatchStore(this._socketService, this._serverlessService, this._firestore) {
    _initSocketListeners();
  }

  // Observable state variables
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

  // Non-action methods

  /// Initializes socket event listeners
  void _initSocketListeners() {
    _socketService
      ..on('chat_ended', _handleChatEnded)
      ..on('friend_request_accepted', _handleFriendRequestAccepted);
  }

  /// Disposes of the store, cancelling any active listeners
  void dispose() {
    stopListeningForMatches();
    _socketService
      ..off('chat_ended')
      ..off('friend_request_accepted');
  }

  /// Processes new snapshots from Firestore
  void _processSnapshot(QuerySnapshot snapshot, String userId,
      Function(String, String) onMatchFound) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        _handleNewMatch(change.doc, userId, onMatchFound);
      }
    }
  }

  /// Handles a new match document
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

  // Actions

  /// Sets the in-queue status
  @action
  void setInQueue(bool value) => isInQueue = value;

  /// Sets the searching status and stops listening for matches if false
  @action
  void setSearching(bool value) {
    isSearching = value;
    if (!value) stopListeningForMatches();
  }

  /// Resets the chat and friend status
  @action
  void resetMatchState() {
    isChatEnded = areFriendsNow = false;
  }

  /// Adds user to the match queue
  @action
  Future<void> addToMatchQueue(Map<String, dynamic> userData) =>
      _serverlessService.addToMatchQueue(userData);

  /// Removes user from the match queue
  @action
  Future<void> removeFromMatchQueue() =>
      _serverlessService.removeFromMatchQueue();

  /// Starts listening for new matches
  @action
  void startListeningForMatches(
      String userId, Function(String, String) onMatchFound) {
    stopListeningForMatches();
    resetMatchState();
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

  /// Stops listening for new matches
  @action
  void stopListeningForMatches() {
    _matchListener?.cancel();
    _matchListener = null;
    lastListenStartTime = null;
  }

  /// Ends the current chat
  @action
  void endChat(String chatId, String userId) {
    _socketService.emit('end_chat', {'chatId': chatId, 'userId': userId});
  }

  /// Sends a friend request
  @action
  void sendFriendRequest(String userId, String chatId) {
    _socketService.emit('add_friend', {'userId': userId, 'chatId': chatId});
  }

  /// Handles the chat ended event
  @action
  void _handleChatEnded(dynamic data) {
    isChatEnded = true;
  }

  /// Handles the friend request accepted event
  @action
  void _handleFriendRequestAccepted(dynamic data) {
    areFriendsNow = true;
    print('Friend request accepted for chat ${data['chatId']}');
  }
}
