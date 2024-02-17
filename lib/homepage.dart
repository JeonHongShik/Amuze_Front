import "package:flutter_speed_dial/flutter_speed_dial.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "package:amuze/chat/widget/chat_list.dart";
import 'package:amuze/chat/screen/chatTest.dart';
import 'package:amuze/chat/widget/chat_list.dart';
import 'package:amuze/community/community_board.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/pagelayout/chatbody.dart';
import 'package:amuze/pagelayout/homebody.dart';
import 'package:amuze/pagelayout/mypage.dart';
import 'package:amuze/pagelayout/notifybody.dart';
import 'package:amuze/resume/resume_board.dart';

import 'stage/stage_board.dart';

class IconChangeProvider extends ChangeNotifier {
  bool _isDialogOpen = false;
  bool get isDialogOpen => _isDialogOpen;

  setDialogOpen(bool isOpen) {
    _isDialogOpen = isOpen;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  final List pages = [
    const HomeBody(),
    const NotifyBody(),
    const SizedBox(),
    //To.준희 ChatBody 대신 너가 만든 페이지 넣으면 될 듯.

    const OtherScreen(),
    const MyPage()
  ];

  void onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyPage()),
      );
    } else {
      setState(() {
        currentPage = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<StageWriteProvider>(context, listen: false).uid =
        Provider.of<UserInfoProvider>(context, listen: false).uid;
    Provider.of<ResumeWriteProvider>(context, listen: false).uid =
        Provider.of<UserInfoProvider>(context, listen: false).uid;
    Provider.of<CommunityWriteProvider>(context, listen: false).uid =
        Provider.of<UserInfoProvider>(context, listen: false).uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'amuze',
          style: TextStyle(
              color: PrimaryColors.basic,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      body: pages.elementAt(currentPage),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          selectedItemColor: SecondaryColors.basic,
          showUnselectedLabels: false,
          unselectedItemColor: SecondaryColors.disabled,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications, size: 30), label: ''),
            BottomNavigationBarItem(
                icon: InkWell(child: SizedBox.shrink()), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble, size: 25), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30), label: '')
          ],
          currentIndex: currentPage,
          onTap: onItemTapped),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: floatingButton(context),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}

// 플로팅버튼 위젯
Widget? floatingButton(context) {
  return SpeedDial(
    overlayColor: Colors.black26,
    overlayOpacity: 0.2,
    animatedIcon: AnimatedIcons.menu_close,
    curve: Curves.bounceIn,
    foregroundColor: SecondaryColors.basic,
    backgroundColor: PrimaryColors.basic,
    children: [
      SpeedDialChild(
        label: '커뮤니티 게시판',
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.groups,
          color: Colors.white,
          size: 31,
        ),
        backgroundColor: PrimaryColors.basic,
        labelBackgroundColor: PrimaryColors.basic,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CommunityBoard()));
        },
      ),
      SpeedDialChild(
        label: '이력서 게시판',
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.assignment_ind,
          color: Colors.white,
          size: 29,
        ),
        backgroundColor: PrimaryColors.basic,
        labelBackgroundColor: PrimaryColors.basic,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResumeBoard()));
        },
      ),
      SpeedDialChild(
        label: '공고 게시판',
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.library_books,
          color: Colors.white,
          size: 27,
        ),
        backgroundColor: PrimaryColors.basic,
        labelBackgroundColor: PrimaryColors.basic,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StageBoard()));
        },
      ),
    ],
  );
}
