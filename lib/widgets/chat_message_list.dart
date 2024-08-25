import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/chat_store.dart';
import 'package:yoto/widgets/message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final String chatId;
  final ScrollController _scrollController = ScrollController();

  ChatMessageList({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatStore = Provider.of<ChatStore>(context);

    return Observer(
      builder: (_) {
        final messages = chatStore.getMessagesForChat(chatId);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return ListView.builder(
          reverse: true,
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageBubble(message: messages[index]);
          },
        );
      },
    );
  }
}
