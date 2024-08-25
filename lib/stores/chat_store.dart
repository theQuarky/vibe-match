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

  @observable
  ObservableMap<String, ObservableList<types.Message>> chatMessages =
      ObservableMap();

  @observable
  String? currentChatType;

  void _initSocketListeners() {
    _socketService
      ..on('new_message', _handleNewMessage)
      ..on('chat_history', _handleChatHistory)
      ..on('chat_type', _handleChatType)
      ..on('friend_request_accepted', _handleFriendRequestAccepted);
  }

  types.TextMessage _createMessage(dynamic msgData) {
    print('msgData $msgData');
    return types.TextMessage(
      author: types.User(id: msgData['senderId']),
      id: msgData['id'],
      text: msgData['text'],
      createdAt: msgData['createdAt'] as int,
    );
  }

  List<types.Message> getMessagesForChat(String chatId) =>
      chatMessages[chatId] ?? [];

  void dispose() {
    _socketService
      ..off('new_message')
      ..off('chat_history')
      ..off('chat_type')
      ..off('friend_request_accepted');
  }

  @action
  void registerUser(String userId) =>
      _socketService.emit('register_user', userId);

  @action
  void _handleNewMessage(dynamic data) {
    print('event listener called with data $data');
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

  @action
  void _handleChatType(dynamic data) {
    currentChatType = data['type'];
  }

  @action
  void _handleFriendRequestAccepted(dynamic data) {
    // Handle friend request accepted event
    // You might want to update UI or perform some action here
    print('Friend request accepted for chat: ${data['chatId']}');
  }

  @action
  Future<void> loadMessages(String chatId) async {
    _socketService.emit('join_chat', chatId);
    _socketService.emit('get_chat_history', {'chatId': chatId});
    _socketService.emit('get_chat_type', {'chatId': chatId});
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
  Future<void> sendFriendRequest(String chatId, String userId) async {
    _socketService.emit('add_friend', {'userId': userId, 'chatId': chatId});
  }

  @action
  Future<void> endChat(String chatId, String userId) async {
    _socketService.emit('end_chat', {'chatId': chatId, 'userId': userId});
  }

  @action
  Future<void> convertToPermanent(
      String anonymousChatId, String permanentChatId) async {
    _socketService.emit('convert_to_permanent', {
      'anonymousChatId': anonymousChatId,
      'permanentChatId': permanentChatId
    });
  }
}
