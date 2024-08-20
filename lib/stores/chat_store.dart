import 'package:mobx/mobx.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:yoto/services/socket_service.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final SocketService _socketService;

  _ChatStore(this._socketService) {
    _initSocketListeners();
  }

  // Observable state
  @observable
  ObservableMap<String, ObservableList<types.Message>> chatMessages =
      ObservableMap();

  // Non-action methods

  /// Initializes socket event listeners
  void _initSocketListeners() {
    _socketService
      ..on('new_message', _handleNewMessage)
      ..on('chat_history', _handleChatHistory);
  }

  /// Creates a TextMessage object from raw message data
  types.TextMessage _createMessage(dynamic msgData) => types.TextMessage(
        author: types.User(id: msgData['senderId']),
        id: msgData['id'],
        text: msgData['text'],
        createdAt: msgData['createdAt'],
      );

  /// Retrieves messages for a specific chat
  List<types.Message> getMessagesForChat(String chatId) =>
      chatMessages[chatId] ?? [];

  /// Disposes of the store, removing socket listeners
  void dispose() {
    _socketService
      ..off('new_message')
      ..off('chat_history');
  }

  // Action methods

  /// Registers a user with the socket service
  @action
  void registerUser(String userId) =>
      _socketService.emit('register_user', {'userId': userId});

  /// Handles new incoming messages
  @action
  void _handleNewMessage(dynamic data) {
    final chatId = data['chatId'];
    final message = _createMessage(data);
    chatMessages
        .putIfAbsent(chatId, () => ObservableList<types.Message>())
        .insert(0, message);
  }

  /// Handles incoming chat history
  @action
  void _handleChatHistory(dynamic data) {
    final chatId = data['chatId'];
    final messages = (data['messages'] as List).map(_createMessage).toList();
    chatMessages[chatId] = ObservableList.of(messages);
  }

  /// Loads messages for a specific chat
  @action
  Future<void> loadMessages(String chatId) async {
    _socketService
      ..emit('join_chat', chatId)
      ..emit('get_chat_history', {'chatId': chatId});
  }

  /// Sends a new message
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

  /// Converts an anonymous chat to a permanent chat
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
}
