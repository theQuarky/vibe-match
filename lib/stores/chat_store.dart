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
    _socketService.on('new_message', _handleNewMessage);
    _socketService.on('chat_history', _handleChatHistory);
  }

  @action
  void registerUser(String userId) {
    _socketService.emit('register_user', {'userId': userId});
  }

  @action
  void _handleNewMessage(dynamic data) {
    final chatId = data['chatId'];
    final message = types.TextMessage(
      author: types.User(id: data['senderId']),
      id: data['id'],
      text: data['text'],
      createdAt: data['createdAt'],
    );

    if (!chatMessages.containsKey(chatId)) {
      chatMessages[chatId] = ObservableList<types.Message>();
    }
    chatMessages[chatId]!.insert(0, message);
  }

  @action
  void _handleChatHistory(dynamic data) {
    final chatId = data['chatId'];
    final messages = (data['messages'] as List)
        .map((msgData) => types.TextMessage(
              author: types.User(id: msgData['senderId']),
              id: msgData['id'],
              text: msgData['text'],
              createdAt: msgData['createdAt'],
            ))
        .toList();

    chatMessages[chatId] = ObservableList.of(messages);
  }

  @action
  Future<void> loadMessages(String chatId, {bool isAnonymous = false}) async {
    _socketService.emit('join_chat', chatId);
    _socketService.emit(
        'get_chat_history', {'chatId': chatId, 'isAnonymous': isAnonymous});
  }

  @action
  Future<void> sendMessage(String chatId, String text, String senderId,
      {bool isAnonymous = false}) async {
    final message = {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'isAnonymous': isAnonymous,
    };

    _socketService.emit('send_message', message);

    // Optimistically add the message to the local list
    if (!chatMessages.containsKey(chatId)) {
      chatMessages[chatId] = ObservableList<types.Message>();
    }

    chatMessages[chatId]!.insert(
      0,
      types.TextMessage(
        author: types.User(id: senderId),
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
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
  void clearAnonymousChat(String chatId) {
    chatMessages.remove(chatId);
    _socketService.emit('clear_anonymous_chat', {'chatId': chatId});
    _socketService.emit('leave_chat', chatId);
  }

  @action
  void endChat(String chatId, String userId) {
    _socketService.emit('end_chat', {'chatId': chatId, 'userId': userId});
    chatMessages.remove(chatId);
    _socketService.emit('leave_chat', chatId);
  }

  List<types.Message> getMessagesForChat(String chatId) {
    return chatMessages[chatId] ?? [];
  }

  void dispose() {
    _socketService.off('new_message');
    _socketService.off('chat_history');
    _socketService.off('chat_ended');
  }
}
