import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'profile_img.dart';

import '../style/style.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton(
      {required this.nickname,
      required this.path,
      this.onProfilePressed,
      super.key});

  final String nickname;
  final String? path;
  final onProfilePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ProfileImage(
          onProfileImagePressed: () => onProfilePressed(context),
          path: path,
          imageSize: 40,
        ),
        const SizedBox(width: 10),
        GestureDetector(
            onTap: () => onProfilePressed(context),
            child: Text(nickname, style: TextStyles.chatNicknameTextStyle)),
      ]),
    );
  }
}
