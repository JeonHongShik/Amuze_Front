import 'package:flutter/material.dart';
import '../../service/chat_service.dart';

class ChatButton extends StatelessWidget {
  final String otherEmail;
  final Future<String> Function(String) onPressed;

  const ChatButton({
    required this.otherEmail,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();

    return ElevatedButton(
      onPressed: () async {
        final String chatRoomId = await chatService.makeChatroomId(otherEmail);
        onPressed(chatRoomId);
      },
      child: Text('Chat with $otherEmail'),
    );
  }
}

// Updated onButtonPressed function
Future<void> onButtonPressed(String chatroomId) async {
  final chatService = ChatService();
  final chatList = await chatService.getChatList();
  final isExist =
      chatList.map((e) => e.chatRoomId).toList().contains(chatroomId);

  if (isExist) {
    // Existing chat room
    // Navigate to existing chat room
  } else {
    // New chat room
    // Navigate to new chat room
  }
}
