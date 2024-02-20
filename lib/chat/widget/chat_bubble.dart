import 'dart:io';

import 'package:amuze/gathercolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amuze/model/chat.dart'; // 채팅과 관련된 모델을 가져옵니다.
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart'; // 이미지 메시지를 표시하기 위해 BubbleNormalImage 위젯을 가져옵니다.
import 'package:chat_bubbles/bubbles/bubble_special_one.dart'; // 텍스트 메시지를 표시하기 위해 BubbleSpecialOne 위젯을 가져옵니다.
import 'package:provider/provider.dart';
import '../../service/member.dart'; // 상대방 정보를 가져오기 위해 Member 서비스를 가져옵니다.
import '../style/profile_screen.dart'; // 프로필 화면을 가져옵니다.
import '../style/style.dart'; // 스타일을 가져옵니다.
import 'chat_time_format.dart'; // 채팅 시간 포맷을 가져옵니다.
import '../../main.dart'; // UserInfoProvider를 가져옵니다.

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.member, {super.key});

  final Message message; // 메시지 객체
  final Member member; // 멤버 객체
  final bool isMe; // 자신이 보낸 메시지 여부

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // 자신이 보낸 메시지인 경우
        if (isMe) ...{
          // 이미지 메시지인 경우
          if (message.content.contains('image@')) ...{
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   dataTimeFormat(message.createdAt), // 메시지 시간을 표시합니다.
                  //   style: TextStyles.shadowTextStyle,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: SizedBox(
                      width: 220,
                      height: 190,
                      child: BubbleNormalImage(
                        id: '1',
                        color: PrimaryColors.basic,
                        image: Image.network(
                          message.content.split('@')[1],
                          fit: BoxFit.cover, // 이미지 URL을 가져와서 이미지를 표시합니다.
                        ),
                        //onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          } else ...{
            // 텍스트 메시지인 경우
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dataTimeFormat(message.createdAt), // 메시지 시간을 표시합니다.
                    style: TextStyles.shadowTextStyle,
                  ),
                  BubbleSpecialOne(
                    text: message.content, // 메시지 내용을 표시합니다.
                    isSender: true,
                    color: PrimaryColors.basic, // 버블의 배경색을 설정합니다.
                    textStyle: TextStyles.blueBottonTextStyle,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.5), // 버블의 텍스트 스타일을 설정합니다.
                  ),
                ],
              ),
            ),
          },
        },
        // 상대방이 보낸 메시지인 경우
        if (!isMe) ...{
          // 이미지 메시지인 경우
          if (message.content.contains('image@')) ...{
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ProfileButton(
                  //   nickname: '' ?? '', // 멤버의 닉네임을 표시합니다.
                  //   path: member.photoURL ?? '', // 멤버의 프로필 사진을 표시합니다.
                  //   onProfilePressed:
                  //       onProfilePressed, // 프로필 버튼을 눌렀을 때의 이벤트 처리기를 설정합니다.
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 190,
                          child: BubbleNormalImage(
                            id: '1',
                            color: const Color.fromARGB(255, 122, 122, 121)
                                .withOpacity(0.3),
                            image: Image.network(
                              message.content.split('@')[1],
                              fit: BoxFit.cover, // 이미지 URL을 가져와서 이미지를 표시합니다.
                            ),
                            onTap: () {},
                          ),
                        ),
                        Text(
                          dataTimeFormat(message.createdAt), // 메시지 시간을 표시합니다.
                          style: TextStyles.shadowTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          } else ...{
            // 텍스트 메시지인 경우
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ProfileButton(
                  //   nickname: '' ?? '테스트', // 멤버의 닉네임을 표시합니다.
                  //   path: member.photoURL ?? '', // 멤버의 프로필 사진을 표시합니다.
                  //   onProfilePressed:
                  //       onProfilePressed, // 프로필 버튼을 눌렀을 때의 이벤트 처리기를 설정합니다.
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BubbleSpecialOne(
                          text: message.content, // 메시지 내용을 표시합니다.
                          isSender: false,
                          color: const Color.fromARGB(255, 122, 122, 121)
                              .withOpacity(0.3), // 버블의 배경색을 설정합니다.
                          textStyle: TextStyles.chatNotMeBubbleTextStyle,
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  0.5), // 버블의 텍스트 스타일을 설정합니다.
                        ),
                        Text(
                          dataTimeFormat(message.createdAt), // 메시지 시간을 표시합니다.
                          style: TextStyles.shadowTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          },
        },
      ],
    );
  }

  // 프로필 화면으로 이동하는 메서드
  void onProfilePressed(BuildContext context, Member member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(member: member),
      ),
    );
  }
}
