// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendStore on _FriendStore, Store {
  Computed<List<Friend>>? _$sortedFriendsComputed;

  @override
  List<Friend> get sortedFriends => (_$sortedFriendsComputed ??=
          Computed<List<Friend>>(() => super.sortedFriends,
              name: '_FriendStore.sortedFriends'))
      .value;

  late final _$friendsAtom =
      Atom(name: '_FriendStore.friends', context: context);

  @override
  ObservableMap<String, Friend> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(ObservableMap<String, Friend> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_FriendStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(name: '_FriendStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadFriendsAsyncAction =
      AsyncAction('_FriendStore.loadFriends', context: context);

  @override
  Future<void> loadFriends(String userId) {
    return _$loadFriendsAsyncAction.run(() => super.loadFriends(userId));
  }

  late final _$_loadFromCacheAsyncAction =
      AsyncAction('_FriendStore._loadFromCache', context: context);

  @override
  Future<void> _loadFromCache() {
    return _$_loadFromCacheAsyncAction.run(() => super._loadFromCache());
  }

  late final _$_saveToCacheAsyncAction =
      AsyncAction('_FriendStore._saveToCache', context: context);

  @override
  Future<void> _saveToCache() {
    return _$_saveToCacheAsyncAction.run(() => super._saveToCache());
  }

  late final _$_FriendStoreActionController =
      ActionController(name: '_FriendStore', context: context);

  @override
  void _updateFriendsFromSnapshot(DocumentSnapshot<Object?> snapshot) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore._updateFriendsFromSnapshot');
    try {
      return super._updateFriendsFromSnapshot(snapshot);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
friends: ${friends},
isLoading: ${isLoading},
error: ${error},
sortedFriends: ${sortedFriends}
    ''';
  }
}
