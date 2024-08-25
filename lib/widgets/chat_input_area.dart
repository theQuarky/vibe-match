import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/chat_store.dart';
import 'package:yoto/stores/auth_store.dart';

class ChatInputArea extends StatefulWidget {
  final String chatId;
  final bool isFriend;

  const ChatInputArea({Key? key, required this.chatId, required this.isFriend})
      : super(key: key);

  @override
  ChatInputAreaState createState() => ChatInputAreaState();
}

class ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _textController = TextEditingController();

  void _handleSendPressed() {
    if (_textController.text.trim().isNotEmpty) {
      final chatStore = Provider.of<ChatStore>(context, listen: false);
      final authStore = Provider.of<AuthStore>(context, listen: false);
      chatStore.sendMessage(widget.chatId, _textController.text.trim(),
          authStore.currentUser!.uid);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final inputBackgroundColor =
        isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final iconColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: backgroundColor,
      child: Row(
        children: [
          if (widget.isFriend)
            IconButton(
              icon: Icon(Icons.add, color: iconColor),
              onPressed: () {
                // Implement add attachment functionality
              },
            ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 40.0,
                maxHeight: 120.0,
              ),
              child: TextField(
                controller: _textController,
                focusNode: FocusNode(),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(color: iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: inputBackgroundColor,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
              ),
            ),
          ),
          if (widget.isFriend)
            IconButton(
              icon: Icon(Icons.mic, color: iconColor),
              onPressed: () {
                // Implement voice message functionality
              },
            ),
          IconButton(
            icon: Icon(Icons.send, color: iconColor),
            onPressed: _handleSendPressed,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
