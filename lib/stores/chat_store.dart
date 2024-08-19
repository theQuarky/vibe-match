import 'package:mobx/mobx.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:yoto/services/socket_service.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final SocketService _socketService;

  @observable
  ObservableMap<String, ObservableList<types.Message>> chatMessages =
      ObservableMap();

  @observable
  String? endedChatId;

  _ChatStore(this._socketService) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _socketService
      ..on('new_message', _handleNewMessage)
      ..on('chat_history', _handleChatHistory)
      ..on('chat_ended', _handleChatEnded);
  }

  @action
  void registerUser(String userId) =>
      _socketService.emit('register_user', {'userId': userId});

  @action
  void _handleNewMessage(dynamic data) {
    final chatId = data['chatId'];
    final message = _createMessage(data);
    chatMessages
        .putIfAbsent(chatId, () => ObservableList<types.Message>())
        .insert(0, message);
  }

  @action
  void _handleChatHistory(dynamic data) {
    final chatId = data['chatId'];
    final messages = (data['messages'] as List).map(_createMessage).toList();
    chatMessages[chatId] = ObservableList.of(messages);
  }

  types.TextMessage _createMessage(dynamic msgData) => types.TextMessage(
        author: types.User(id: msgData['senderId']),
        id: msgData['id'],
        text: msgData['text'],
        createdAt: msgData['createdAt'],
      );

  @action
  void _handleChatEnded(dynamic data) {
    final chatId = data['chatId'];
    endedChatId = chatId;
    chatMessages.remove(chatId);
  }

  @action
  Future<void> loadMessages(String chatId) async {
    _socketService
      ..emit('join_chat', chatId)
      ..emit('get_chat_history', {'chatId': chatId});
  }

  @action
  Future<void> sendMessage(String chatId, String text, String senderId) async {
    final message = {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
    };

    _socketService.emit('send_message', message);

    // Optimistically add the message to the local list
    final localMessage = types.TextMessage(
      author: types.User(id: senderId),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    chatMessages
        .putIfAbsent(chatId, () => ObservableList<types.Message>())
        .insert(0, localMessage);
  }

  @action
  Future<void> convertToPermamentChat(
      String anonymousChatId, String permanentChatId) async {
    _socketService.emit('convert_to_permanent', {
      'anonymousChatId': anonymousChatId,
      'permanentChatId': permanentChatId,
    });

    // Update local state
    chatMessages[permanentChatId] = chatMessages[anonymousChatId]!;
    chatMessages.remove(anonymousChatId);
  }

  @action
  void endChat(String chatId, String userId) {
    _socketService.emit('end_chat', {'chatId': chatId, 'userId': userId});
    chatMessages.remove(chatId);
    _socketService.emit('leave_chat', chatId);
  }

  List<types.Message> getMessagesForChat(String chatId) =>
      chatMessages[chatId] ?? [];

  void dispose() {
    _socketService
      ..off('new_message')
      ..off('chat_history')
      ..off('chat_ended');
  }
}
