import 'package:flutter/cupertino.dart';
import '../../service/member.dart';

import '../../model/chat.dart';
import 'chat_bubble.dart';

class Messages extends StatelessWidget {
  const Messages(
      {super.key,
      required this.messages,
      required this.userId,
      required this.member});

  final List<Message> messages;
  final String? userId;
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return ChatBubbles(
                messages[index], messages[index].sender == userId, member);
          },
        ));
  }
}
