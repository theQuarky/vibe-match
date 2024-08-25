import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/friend_store.dart';
import 'package:yoto/stores/chat_store.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:yoto/widgets/custome_chat_list_item.dart'; // Adjust the import based on your folder structure

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({Key? key}) : super(key: key);

  @override
  FriendListScreenState createState() => FriendListScreenState();
}

class FriendListScreenState extends State<FriendListScreen> {
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      final friendStore = Provider.of<FriendStore>(context, listen: false);
      friendStore.loadFriends(authStore.currentUser!.uid).then((_) {
        if (mounted) {
          setState(() {
            _initialLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: _initialLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildFriendList(),
    );
  }

  Widget _buildFriendList() {
    return Consumer<FriendStore>(
      builder: (context, friendStore, child) {
        if (friendStore.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (friendStore.error != null) {
          return Center(child: Text('Error: ${friendStore.error}'));
        }
        if (friendStore.friends.isEmpty) {
          return const Center(child: Text('No friends found.'));
        }
        return ListView.builder(
          itemCount: friendStore.sortedFriends.length,
          itemBuilder: (context, index) {
            final friend = friendStore.sortedFriends[index];
            return CustomChatListItem(
              friend: friend,
              onTap: () {
                // Navigate to the chat screen
                Navigator.of(context).pushNamed(
                  '/chat',
                  arguments: {
                    'chatId': friend.id, // This is your unique chat ID
                    'friendId': friend.id, // The friend's user ID
                    'isFriend': true
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
