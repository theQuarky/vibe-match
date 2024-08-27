// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MatchStore on _MatchStore, Store {
  late final _$isInQueueAtom =
      Atom(name: '_MatchStore.isInQueue', context: context);

  @override
  bool get isInQueue {
    _$isInQueueAtom.reportRead();
    return super.isInQueue;
  }

  @override
  set isInQueue(bool value) {
    _$isInQueueAtom.reportWrite(value, super.isInQueue, () {
      super.isInQueue = value;
    });
  }

  late final _$isSearchingAtom =
      Atom(name: '_MatchStore.isSearching', context: context);

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  late final _$isChatEndedAtom =
      Atom(name: '_MatchStore.isChatEnded', context: context);

  @override
  bool get isChatEnded {
    _$isChatEndedAtom.reportRead();
    return super.isChatEnded;
  }

  @override
  set isChatEnded(bool value) {
    _$isChatEndedAtom.reportWrite(value, super.isChatEnded, () {
      super.isChatEnded = value;
    });
  }

  late final _$areFriendsNowAtom =
      Atom(name: '_MatchStore.areFriendsNow', context: context);

  @override
  bool get areFriendsNow {
    _$areFriendsNowAtom.reportRead();
    return super.areFriendsNow;
  }

  @override
  set areFriendsNow(bool value) {
    _$areFriendsNowAtom.reportWrite(value, super.areFriendsNow, () {
      super.areFriendsNow = value;
    });
  }

  late final _$lastListenStartTimeAtom =
      Atom(name: '_MatchStore.lastListenStartTime', context: context);

  @override
  DateTime? get lastListenStartTime {
    _$lastListenStartTimeAtom.reportRead();
    return super.lastListenStartTime;
  }

  @override
  set lastListenStartTime(DateTime? value) {
    _$lastListenStartTimeAtom.reportWrite(value, super.lastListenStartTime, () {
      super.lastListenStartTime = value;
    });
  }

  late final _$_matchListenerAtom =
      Atom(name: '_MatchStore._matchListener', context: context);

  @override
  StreamSubscription<QuerySnapshot<Object?>>? get _matchListener {
    _$_matchListenerAtom.reportRead();
    return super._matchListener;
  }

  @override
  set _matchListener(StreamSubscription<QuerySnapshot<Object?>>? value) {
    _$_matchListenerAtom.reportWrite(value, super._matchListener, () {
      super._matchListener = value;
    });
  }

  late final _$currentMatchAtom =
      Atom(name: '_MatchStore.currentMatch', context: context);

  @override
  Map<String, dynamic>? get currentMatch {
    _$currentMatchAtom.reportRead();
    return super.currentMatch;
  }

  @override
  set currentMatch(Map<String, dynamic>? value) {
    _$currentMatchAtom.reportWrite(value, super.currentMatch, () {
      super.currentMatch = value;
    });
  }

  late final _$addToMatchQueueAsyncAction =
      AsyncAction('_MatchStore.addToMatchQueue', context: context);

  @override
  Future<bool> addToMatchQueue(Map<String, dynamic> userData) {
    return _$addToMatchQueueAsyncAction
        .run(() => super.addToMatchQueue(userData));
  }

  late final _$removeFromMatchQueueAsyncAction =
      AsyncAction('_MatchStore.removeFromMatchQueue', context: context);

  @override
  Future<void> removeFromMatchQueue() {
    return _$removeFromMatchQueueAsyncAction
        .run(() => super.removeFromMatchQueue());
  }

  late final _$convertToPermanentAsyncAction =
      AsyncAction('_MatchStore.convertToPermanent', context: context);

  @override
  Future<void> convertToPermanent(
      String anonymousChatId, String permanentChatId) {
    return _$convertToPermanentAsyncAction
        .run(() => super.convertToPermanent(anonymousChatId, permanentChatId));
  }

  late final _$_MatchStoreActionController =
      ActionController(name: '_MatchStore', context: context);

  @override
  void setInQueue(bool value) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.setInQueue');
    try {
      return super.setInQueue(value);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearching(bool value) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.setSearching');
    try {
      return super.setSearching(value);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetMatchState() {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.resetMatchState');
    try {
      return super.resetMatchState();
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startListeningForMatches(
      String userId, dynamic Function(String, String) onMatchFound) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.startListeningForMatches');
    try {
      return super.startListeningForMatches(userId, onMatchFound);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopListeningForMatches() {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.stopListeningForMatches');
    try {
      return super.stopListeningForMatches();
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void endChat(String chatId, String userId) {
    final _$actionInfo =
        _$_MatchStoreActionController.startAction(name: '_MatchStore.endChat');
    try {
      return super.endChat(chatId, userId);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendFriendRequest(String userId, String chatId) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.sendFriendRequest');
    try {
      return super.sendFriendRequest(userId, chatId);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleChatEnded(dynamic data) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore._handleChatEnded');
    try {
      return super._handleChatEnded(data);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleFriendRequestAccepted(dynamic data) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore._handleFriendRequestAccepted');
    try {
      return super._handleFriendRequestAccepted(data);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isInQueue: ${isInQueue},
isSearching: ${isSearching},
isChatEnded: ${isChatEnded},
areFriendsNow: ${areFriendsNow},
lastListenStartTime: ${lastListenStartTime},
currentMatch: ${currentMatch}
    ''';
  }
}
