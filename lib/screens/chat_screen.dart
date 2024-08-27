import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:yoto/widgets/chat_appbar.dart';
import 'package:yoto/widgets/chat_input_area.dart';
import 'package:yoto/widgets/chat_message_list.dart';
import 'package:yoto/stores/chat_store.dart';
import 'package:yoto/stores/match_store.dart';
import 'package:yoto/services/chat_timer_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String friendId;
  final bool isFriend;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.friendId,
    this.isFriend = false,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late ChatTimerService _timerService;
  bool _isNavigating = false;
  @override
  void initState() {
    super.initState();
    _timerService = ChatTimerService(
      isFriend: widget.isFriend,
      onTimerEnd: _endChat,
    );
    _loadMessages();
  }

  void _loadMessages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatStore>(context, listen: false)
          .loadMessages(widget.chatId);
    });
  }

  void _endChat() {
    if (!widget.isFriend) {
      Provider.of<MatchStore>(context, listen: false)
          .endChat(widget.chatId, widget.friendId);
      _navigateToHome();
    }
  }

  void _addFriend() {
    if (!widget.isFriend) {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      Provider.of<MatchStore>(context, listen: false)
          .sendFriendRequest(authStore.currentUser!.uid, widget.chatId);
    }
  }

  void _navigateToHome() {
    if (!_isNavigating) {
      _isNavigating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchStore = Provider.of<MatchStore>(context);

    return Observer(
      builder: (context) {
        if (matchStore.isChatEnded && !_isNavigating) {
          _navigateToHome();
        }
        bool isFriend = widget.isFriend || matchStore.areFriendsNow;
        return Scaffold(
          appBar: _TimerAppBar(
            timerValueListenable: _timerService.secondsRemaining,
            builder: (context, secondsRemaining) {
              return ChatAppBar(
                friendId: widget.friendId,
                isFriend: isFriend,
                timerValue: secondsRemaining,
                onAddFriend: _addFriend,
                onEndChat: _endChat,
              );
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: ChatMessageList(chatId: widget.chatId),
              ),
              ChatInputArea(chatId: widget.chatId, isFriend: isFriend),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }
}

class _TimerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueListenable<int> timerValueListenable;
  final Widget Function(BuildContext, int) builder;

  const _TimerAppBar({
    Key? key,
    required this.timerValueListenable,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: timerValueListenable,
      builder: (context, value, child) => builder(context, value),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
