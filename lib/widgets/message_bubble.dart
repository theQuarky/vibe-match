import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:yoto/stores/auth_store.dart';

class MessageBubble extends StatelessWidget {
  final dynamic message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final isMe = message.author.id == authStore.currentUser!.uid;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final myMessageColor = isDarkMode ? Colors.teal[700] : Colors.blue[100];
    final otherMessageColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final timestampColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isMe ? myMessageColor : otherMessageColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(message.createdAt),
              ),
              style: TextStyle(
                fontSize: 12,
                color: timestampColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}