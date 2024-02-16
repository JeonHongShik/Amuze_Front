import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
    required this.onProfileImagePressed,
    required this.path,
    required this.imageSize,
  }) : super(key: key);

  final Function() onProfileImagePressed;
  final String? path;
  final double imageSize;

  @override
  State<ProfileImage> createState() => ProfileImageState();
}

class ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onProfileImagePressed,
        child: Container(
          width: widget.imageSize,
          height: widget.imageSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            image: DecorationImage(
                image: widget.path != null
                    ? NetworkImage(widget.path!)
                    : const AssetImage('assets/images/default_user_profile.png')
                        as ImageProvider,
                fit: BoxFit.cover),
          ),
        ));
  }
}
