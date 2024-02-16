import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../style/style.dart';
import '../../main.dart';
import '../../model/chat.dart';
import '../../service/member.dart';
import '../screen/chat_screen.dart';
import '../style/profile_img.dart';
import '../style/profile_screen.dart';
import 'chat_time_format.dart';

class ChatList extends StatelessWidget {
  const ChatList({this.chats, super.key});

  final List<MyChat>? chats;

  @override
  Widget build(BuildContext context) {
    if (chats == null || chats!.isEmpty) {
      return Center(
        child: Text("No chats available"),
      );
    }
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    onProfilePressed(BuildContext context, String email) async {
      final member = await userInfoProvider.getMemberInfo(email);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    member: member,
                  )));
    }

    void toChatroom(String chatroomId, Member member) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatroomId: chatroomId,
                    isNew: false,
                    other: member,
                  )));
    }

    onButtonPressed(String email) async {
      final user = FirebaseAuth.instance.currentUser;
      String userEmail = user!.email!;
      final list = [userEmail, email];
      list.sort();
      String roomId = list.join('&').replaceAll('.', '');
      final other = await userInfoProvider.getMemberInfo(email);

      toChatroom(roomId, other);
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: chats!.length,
        padding: const EdgeInsets.only(bottom: 40),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () => onButtonPressed(
                    chats!.elementAt(index).otherEmail,
                  ),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 20),
                  child: Stack(children: [
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(children: [
                            GestureDetector(
                              onTap: () => onProfilePressed(
                                  context, chats!.elementAt(index).otherEmail),
                              child: ProfileImage(
                                onProfileImagePressed: () => onProfilePressed(
                                    context,
                                    chats!.elementAt(index).otherEmail),
                                path: chats![index].otherPhotoUrl,
                                imageSize: 50,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(chats![index].otherName,
                                    style: TextStyles.chatHeading),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(chats![index].lastMessage,
                                    style: TextStyles.chatbodyText),
                              ],
                            ),
                          ]),
                          // Text(dataTimeFormat(chats![index].lastTime),
                          //     style: TextStyles.chatbodyText),
                        ]),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(dataTimeFormat(chats![index].lastTime),
                          style: TextStyles.chatTimeText),
                    )
                  ])));
        });
  }
}
