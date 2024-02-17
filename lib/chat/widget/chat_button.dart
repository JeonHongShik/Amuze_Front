import 'package:amuze/gathercolors.dart';
import 'package:flutter/material.dart';
import '../../service/chat_service.dart';

class ChatButton extends StatelessWidget {
  final String otherEmail;
  final Future<String> Function(String) onPressed;

  const ChatButton({
    required this.otherEmail,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(PrimaryColors.basic),
          minimumSize: MaterialStateProperty.all(const Size(200, 50))),
      onPressed: () async {
        final String chatRoomId = await chatService.makeChatroomId(otherEmail);
        onPressed(chatRoomId);
      },
      child: const Text(
        '채팅',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
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
