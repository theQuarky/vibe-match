import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:yoto/stores/chat_store.dart';

class AnonymousChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  const AnonymousChatScreen({
    Key? key,
    required this.chatId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  AnonymousChatScreenState createState() => AnonymousChatScreenState();
}

class AnonymousChatScreenState extends State<AnonymousChatScreen> {
  late Timer _timer;
  int _secondsRemaining = 15 * 60; // 15 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatStore = Provider.of<ChatStore>(context, listen: false);
      chatStore.loadMessages(widget.chatId, isAnonymous: true);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _endChat();
        }
      });
    });
  }

  void _endChat() {
    _timer.cancel();
    final chatStore = Provider.of<ChatStore>(context, listen: false);
    chatStore.clearAnonymousChat(widget.chatId);
    Navigator.of(context).pop();
  }

  Future<void> _addFriend() async {
    final chatStore = Provider.of<ChatStore>(context, listen: false);
    try {
      await chatStore.convertToPermamentChat(
          widget.chatId, 'new_permanent_chat_id');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend added successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add friend: $e')),
      );
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    final chatStore = Provider.of<ChatStore>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.teal,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Anonymous Chat'),
              Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'addFriend') {
                  _addFriend();
                } else if (value == 'endChat') {
                  _endChat();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'addFriend',
                  child: Text('Add Friend'),
                ),
                const PopupMenuItem<String>(
                  value: 'endChat',
                  child: Text('End Chat'),
                ),
              ],
            ),
          ],
        ),
        body: Observer(builder: (_) {
          if (chatStore.endedChatId == widget.chatId) {
            // Chat has ended, navigate back to home
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
            return const Center(child: CircularProgressIndicator());
          }
          return Chat(
            messages: chatStore.getMessagesForChat(widget.chatId),
            onSendPressed: (types.PartialText message) {
              chatStore.sendMessage(
                widget.chatId,
                message.text,
                authStore.currentUser!.uid,
                isAnonymous: true,
              );
            },
            user: types.User(id: authStore.currentUser!.uid),
            theme:
                isDarkMode ? const DarkChatTheme() : const DefaultChatTheme(),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
