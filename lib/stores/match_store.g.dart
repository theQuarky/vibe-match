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
  Future<void> addToMatchQueue(Map<String, dynamic> userData) {
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
  void startListeningForMatches(String userId, Function onMatchFound) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.startListeningForMatches');
    try {
      return super.startListeningForMatches(userId, onMatchFound);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleNewMatch(
      DocumentSnapshot<Object?> doc, String userId, Function onMatchFound) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore._handleNewMatch');
    try {
      return super._handleNewMatch(doc, userId, onMatchFound);
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
  String toString() {
    return '''
isInQueue: ${isInQueue},
currentMatch: ${currentMatch}
    ''';
  }
}
