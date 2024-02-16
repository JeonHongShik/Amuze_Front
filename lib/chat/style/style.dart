import 'package:flutter/material.dart';

class Palette {
  static const Color bottomSelectedColor = Color.fromRGBO(63, 66, 72, 1);
  static const Color bottomUnselectedColor = Color.fromRGBO(204, 210, 223, 1);
  static const Color boxContainerColor = Color.fromRGBO(238, 241, 244, 0.729);
}

class TextStyles {
  static const TextStyle underlineTextStyle = TextStyle(
    color: Color(0xFFC3C3C3),
    decoration: TextDecoration.underline,
    decorationThickness: 1.5,
  );
  static const TextStyle appbarTextStyle = TextStyle(
    color: Colors.black54,
    fontSize: 20,
    fontStyle: FontStyle.italic,
  );

  static const splashScreenTextStyle = TextStyle(
      color: Color.fromARGB(196, 0, 0, 0),
      fontSize: 33,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.4);

  static const TextStyle shadowTextStyle = TextStyle(
      letterSpacing: 0.04,
      fontSize: 14,
      color: Color.fromRGBO(82, 82, 82, 0.644));

  static const TextStyle homeTitleTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle editProfileTitleTextStyle = TextStyle(
      color: Color.fromARGB(221, 26, 26, 26),
      fontSize: 14,
      fontWeight: FontWeight.w600);

  static const TextStyle appbarIconTextStyle =
      TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.w500);
  static const TextStyle communityWriterTextStyle = TextStyle(
      height: 1.4,
      fontSize: 13,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.3);

  static const TextStyle communityContentTextStyle = TextStyle(
      height: 1.4,
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.3);

  static const TextStyle classContentTextStyle = TextStyle(
      height: 1.2,
      fontSize: 13,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2);

  static const TextStyle hobbyTitleTextStyle = TextStyle(
      color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500);
  static const TextStyle classWeekTitleTextStyle =
      TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500);
  static const TextStyle classWeekContentTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle blueBottonTextStyle = TextStyle(
      letterSpacing: 0.04,
      fontSize: 17,
      color: Color.fromRGBO(255, 255, 255, 1));
  static const TextStyle chatNicknameTextStyle =
      TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600);
  static const TextStyle chatNotMeBubbleTextStyle = TextStyle(
      fontSize: 17,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w400);
  static const TextStyle classWeekContentDetailTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2);

  static const TextStyle chatHeading = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );
  static TextStyle chatbodyText = TextStyle(
      color: Colors.black.withOpacity(0.8),
      fontSize: 14,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w500);
  static TextStyle chatTimeText = TextStyle(
      color: Colors.black.withOpacity(0.8),
      fontSize: 11,
      fontWeight: FontWeight.w500);

  static const TextStyle errorTextStyle = TextStyle(
      fontSize: 18,
      height: 1.4,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontWeight: FontWeight.w500);
  static const TextStyle optionButtonTextStyle = TextStyle(
      color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal);
}
