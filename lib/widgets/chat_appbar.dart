import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/friend_store.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String friendId;
  final bool isFriend;
  final int timerValue;
  final VoidCallback onEndChat;

  const ChatAppBar({
    Key? key,
    required this.friendId,
    required this.isFriend,
    required this.timerValue,
    required this.onEndChat,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _ChatAppBarState createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  String friendName = 'Strange';
  String avatar = '';

  @override
  void initState() {
    super.initState();
    if (widget.isFriend) {
      _loadFriendProfile();
    }
  }

  Future<void> _loadFriendProfile() async {
    final friendStore = Provider.of<FriendStore>(context, listen: false);
    final friendProfile = await friendStore.getFriendProfile(widget.friendId);
    if (friendProfile != null) {
      setState(() {
        friendName = friendProfile['displayName'];
        avatar = friendProfile['profileImageUrl'];
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        friendName,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (!widget.isFriend) ...[
          Center(
            child: Text(
              _formatTime(widget.timerValue),
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sendFriendRequest') {
                // Implement send friend request
              } else if (value == 'endChat') {
                widget.onEndChat();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'sendFriendRequest',
                child: Text('Send Friend Request'),
              ),
              const PopupMenuItem<String>(
                value: 'endChat',
                child: Text('End Chat'),
              ),
            ],
          ),
        ] else ...[
          CircleAvatar(
            backgroundImage: NetworkImage(avatar),
            radius: 18,
          ),
        ],
        const SizedBox(width: 16),
      ],
    );
  }
}
