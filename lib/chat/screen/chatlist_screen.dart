import 'package:amuze/gathercolors.dart';
import 'package:amuze/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/chat_list.dart';
import 'package:amuze/service/chat_service.dart';
import '../style/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<List<MyChat>?>(
          stream: _chatListStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingCube(
                  color: PrimaryColors.basic,
                  size: 30.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  '대화 중인 채팅방이 없습니다.',
                  style: TextStyle(color: TextColors.disabled),
                ),
              );
            } else {
              print('////////////////${snapshot.data.toString()}');
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
