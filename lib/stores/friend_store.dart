import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoto/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:yoto/services/graphql_service.dart';

part 'friend_store.g.dart';

class FriendStore = _FriendStore with _$FriendStore;

abstract class _FriendStore with Store {
  final FirestoreService _firestoreService;
  final Graphqlservice _graphqlservice;
  final String _cacheKey = 'friends_cache';

  _FriendStore(this._firestoreService, this._graphqlservice);

  @observable
  ObservableMap<String, Friend> friends = ObservableMap<String, Friend>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @computed
  List<Friend> get sortedFriends {
    final List<Friend> sortedList = friends.values.toList();
    sortedList.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return sortedList;
  }

  @action
  Future<void> loadFriends(String userId) async {
    print("loadFriends called for user: $userId");

    isLoading = true;
    error = null;

    try {
      print("Attempting to load from cache");
      await _loadFromCache();

      print("Getting friends stream for user: $userId");
      final stream = _firestoreService.getFriendsStream(userId);

      print("Waiting for first value from stream");
      final initialSnapshot = await stream.first;
      print(
          "Received initial snapshot: ${initialSnapshot.exists ? "exists" : "does not exist"}");

      if (!initialSnapshot.exists) {
        print("No friends data found for user: $userId");
        friends.clear();
      } else {
        print("Updating friends from initial snapshot");
        _updateFriendsFromSnapshot(initialSnapshot);
      }

      print("Setting up stream listener");
      stream.listen(
        (snapshot) {
          print(
              "Received snapshot from stream: ${snapshot.exists ? "exists" : "does not exist"}");
          if (snapshot.exists) {
            print("Updating friends from snapshot");
            _updateFriendsFromSnapshot(snapshot);
            _saveToCache();
          } else {
            print("Snapshot does not exist, clearing friends");
            friends.clear();
          }
        },
        onError: (e) {
          print("Error in Firestore stream: $e");
          error = 'Failed to load friends: $e';
          isLoading = false;
        },
      );
    } catch (e) {
      print("Error in loadFriends: $e");
      error = 'Failed to load friends: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> decoded = jsonDecode(cachedData);
      friends = ObservableMap.of(Map.fromEntries(decoded.map((item) {
        final friend = Friend.fromJson(item);
        return MapEntry(friend.id, friend);
      })));
    }
  }

  @action
  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(friends.values.toList());
    await prefs.setString(_cacheKey, encoded);
  }

  @action
  void _updateFriendsFromSnapshot(DocumentSnapshot snapshot) {
    final friendsData = snapshot.data() as Map<String, dynamic>?;

    if (friendsData != null) {
      friends = ObservableMap.of(friendsData.map((key, value) {
        return MapEntry(
          key,
          Friend(
            id: key,
            chatId: value['chatId'],
            displayName: value['displayName'] ?? 'Unknown User',
            profileImageUrl: value['profileImageUrl'],
            lastMessage: value['lastMessage'] ?? 'No messages yet',
            lastMessageTime: value['lastMessageTime'] is Timestamp
                ? value['lastMessageTime']
                : Timestamp.fromMillisecondsSinceEpoch(
                    value['lastMessageTime'] ?? 0),
            unreadCount: value['unreadCount'] ?? 0,
          ),
        );
      }));
    } else {
      print("No friends data in snapshot");
      friends.clear();
    }
  }

  @action
  Future<Map<String, dynamic>?> getFriendProfile(String friendId) async {
    return await _graphqlservice.getFriendProfile(friendId);
  }
}

class Friend {
  final String id;
  final String chatId;
  final String displayName;
  final String? profileImageUrl;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final int unreadCount;

  Friend({
    required this.id,
    required this.chatId,
    required this.displayName,
    this.profileImageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      chatId: json['chatId'],
      displayName: json['displayName'],
      profileImageUrl: json['profileImageUrl'],
      lastMessage: json['lastMessage'],
      lastMessageTime:
          Timestamp.fromMillisecondsSinceEpoch(json['lastMessageTime']),
      unreadCount: json['unreadCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
    };
  }
}
