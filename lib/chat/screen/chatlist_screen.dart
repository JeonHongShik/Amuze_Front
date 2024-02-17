import 'package:amuze/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/chat_list.dart';
import 'package:amuze/service/chat_service.dart';
import '../style/style.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Stream<List<MyChat>?> _chatListStream;

  @override
  void initState() {
    super.initState();
    _chatListStream = ChatService().getChatListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: StreamBuilder<List<MyChat>?>(
          stream: _chatListStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No chats yet',
                  style: TextStyles.shadowTextStyle,
                ),
              );
            } else {
              return ListView(
                children: [
                  ChatList(chats: snapshot.data!),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
