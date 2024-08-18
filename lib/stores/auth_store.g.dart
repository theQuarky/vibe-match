// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<bool>? _$isLoggedInComputed;

  @override
  bool get isLoggedIn => (_$isLoggedInComputed ??=
          Computed<bool>(() => super.isLoggedIn, name: '_AuthStore.isLoggedIn'))
      .value;

  late final _$currentUserAtom =
      Atom(name: '_AuthStore.currentUser', context: context);

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$signInAsyncAction =
      AsyncAction('_AuthStore.signIn', context: context);

  @override
  Future<void> signIn(String email, String password) {
    return _$signInAsyncAction.run(() => super.signIn(email, password));
  }

  late final _$signUpAsyncAction =
      AsyncAction('_AuthStore.signUp', context: context);

  @override
  Future<void> signUp(String email, String password) {
    return _$signUpAsyncAction.run(() => super.signUp(email, password));
  }

  late final _$signOutAsyncAction =
      AsyncAction('_AuthStore.signOut', context: context);

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$initAsyncAction =
      AsyncAction('_AuthStore.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
isLoggedIn: ${isLoggedIn}
    ''';
  }
}
