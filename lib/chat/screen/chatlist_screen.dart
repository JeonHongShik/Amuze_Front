import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/chat_list.dart';
import 'package:amuze/service/chat_service.dart'; // 이 부분을 수정하셔야 합니다.
import '../style/style.dart';

final chatListProvider =
    StreamProvider.autoDispose((ref) => ChatService().getChatListData());

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Recent Chats', style: TextStyles.titleTextStyle),
            const SizedBox(height: 20),

            chatList.when(
              data: (item) => item.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No chats yet',
                          style: TextStyles.shadowTextStyle,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ChatList(
                        chats: item,
                      ),
                    ),
              error: (e, st) => Expanded(
                child: Center(
                  child: Text('Error: $e'),
                ),
              ),
              loading: () => Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
