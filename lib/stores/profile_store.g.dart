// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  Computed<bool>? _$isProfileCompleteComputed;

  @override
  bool get isProfileComplete => (_$isProfileCompleteComputed ??= Computed<bool>(
          () => super.isProfileComplete,
          name: '_ProfileStore.isProfileComplete'))
      .value;

  late final _$profileDataAtom =
      Atom(name: '_ProfileStore.profileData', context: context);

  @override
  Map<String, dynamic>? get profileData {
    _$profileDataAtom.reportRead();
    return super.profileData;
  }

  @override
  set profileData(Map<String, dynamic>? value) {
    _$profileDataAtom.reportWrite(value, super.profileData, () {
      super.profileData = value;
    });
  }

  late final _$fetchProfileDataAsyncAction =
      AsyncAction('_ProfileStore.fetchProfileData', context: context);

  @override
  Future<void> fetchProfileData() {
    return _$fetchProfileDataAsyncAction.run(() => super.fetchProfileData());
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_ProfileStore.updateProfile', context: context);

  @override
  Future<void> updateProfile(Map<String, dynamic> newData) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(newData));
  }

  late final _$_loadFromCacheAsyncAction =
      AsyncAction('_ProfileStore._loadFromCache', context: context);

  @override
  Future<void> _loadFromCache() {
    return _$_loadFromCacheAsyncAction.run(() => super._loadFromCache());
  }

  late final _$_saveToCacheAsyncAction =
      AsyncAction('_ProfileStore._saveToCache', context: context);

  @override
  Future<void> _saveToCache() {
    return _$_saveToCacheAsyncAction.run(() => super._saveToCache());
  }

  @override
  String toString() {
    return '''
profileData: ${profileData},
isProfileComplete: ${isProfileComplete}
    ''';
  }
}
