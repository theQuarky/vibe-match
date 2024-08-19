// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MatchStore on _MatchStore, Store {
  late final _$endedChatIdAtom =
      Atom(name: '_MatchStore.endedChatId', context: context);

  @override
  String? get endedChatId {
    _$endedChatIdAtom.reportRead();
    return super.endedChatId;
  }

  @override
  set endedChatId(String? value) {
    _$endedChatIdAtom.reportWrite(value, super.endedChatId, () {
      super.endedChatId = value;
    });
  }

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
  Future<void> addToMatchQueue(Map<String, dynamic> userData) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.addToMatchQueue');
    try {
      return super.addToMatchQueue(userData);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> removeFromMatchQueue() {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.removeFromMatchQueue');
    try {
      return super.removeFromMatchQueue();
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
  void listenForChatEnd(String chatId, dynamic Function(String) onChatEnded) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.listenForChatEnd');
    try {
      return super.listenForChatEnd(chatId, onChatEnded);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopListeningForChatEnd() {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.stopListeningForChatEnd');
    try {
      return super.stopListeningForChatEnd();
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
endedChatId: ${endedChatId},
isInQueue: ${isInQueue},
currentMatch: ${currentMatch},
isSearching: ${isSearching},
lastListenStartTime: ${lastListenStartTime}
    ''';
  }
}
