// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  late final _$chatMessagesAtom =
      Atom(name: '_ChatStore.chatMessages', context: context);

  @override
  ObservableMap<String, ObservableList<types.Message>> get chatMessages {
    _$chatMessagesAtom.reportRead();
    return super.chatMessages;
  }

  @override
  set chatMessages(ObservableMap<String, ObservableList<types.Message>> value) {
    _$chatMessagesAtom.reportWrite(value, super.chatMessages, () {
      super.chatMessages = value;
    });
  }

  late final _$endedChatIdAtom =
      Atom(name: '_ChatStore.endedChatId', context: context);

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

  late final _$loadMessagesAsyncAction =
      AsyncAction('_ChatStore.loadMessages', context: context);

  @override
  Future<void> loadMessages(String chatId) {
    return _$loadMessagesAsyncAction.run(() => super.loadMessages(chatId));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('_ChatStore.sendMessage', context: context);

  @override
  Future<void> sendMessage(String chatId, String text, String senderId) {
    return _$sendMessageAsyncAction
        .run(() => super.sendMessage(chatId, text, senderId));
  }

  late final _$convertToPermamentChatAsyncAction =
      AsyncAction('_ChatStore.convertToPermamentChat', context: context);

  @override
  Future<void> convertToPermamentChat(
      String anonymousChatId, String permanentChatId) {
    return _$convertToPermamentChatAsyncAction.run(
        () => super.convertToPermamentChat(anonymousChatId, permanentChatId));
  }

  late final _$_ChatStoreActionController =
      ActionController(name: '_ChatStore', context: context);

  @override
  void registerUser(String userId) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.registerUser');
    try {
      return super.registerUser(userId);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleNewMessage(dynamic data) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore._handleNewMessage');
    try {
      return super._handleNewMessage(data);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleChatHistory(dynamic data) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore._handleChatHistory');
    try {
      return super._handleChatHistory(data);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleChatEnded(dynamic data) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore._handleChatEnded');
    try {
      return super._handleChatEnded(data);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void endChat(String chatId, String userId) {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.endChat');
    try {
      return super.endChat(chatId, userId);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chatMessages: ${chatMessages},
endedChatId: ${endedChatId}
    ''';
  }
}
