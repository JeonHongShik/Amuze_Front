import 'package:amuze/community/community_board.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/pagelayout/chatbody.dart';
import 'package:amuze/pagelayout/homebody.dart';
import 'package:amuze/pagelayout/mypage.dart';
import 'package:amuze/pagelayout/notifybody.dart';
import 'package:amuze/resume/resume_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'stage/stage_board.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }
}

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
  late BottomNavigationProvider _bottomNavigationProvider;

  // late IconChangeProvider _iconChangeProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<StageWriteProvider>(context, listen: false).uid =
        Provider.of<UserInfoProvider>(context, listen: false).uid;
    Provider.of<ResumeWriteProvider>(context, listen: false).uid =
        Provider.of<UserInfoProvider>(context, listen: false).uid;
    Provider.of<CommunityWriteProvider>(context, listen: false).uid =
        Provider.of<UserInfoProvider>(context, listen: false).uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(MediaQuery.of(context).size.width);
    });
  }

  @override
  Widget build(BuildContext context) {
    _bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);
    // _iconChangeProvider = Provider.of<IconChangeProvider>(context);

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
      body: const [
        HomeBody(),
        NotifyBody(),
        SizedBox(), //가운데 비게 하기 위함.
        ChatBody(),
        MyPage(),
      ].elementAt(_bottomNavigationProvider.currentPage),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        selectedItemColor: SecondaryColors.basic,
        showUnselectedLabels: false,
        unselectedItemColor: SecondaryColors.basic,
        type: BottomNavigationBarType.fixed,
        backgroundColor: TertiaryColors.basic,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications, size: 30), label: ''),
          BottomNavigationBarItem(
              icon: InkWell(child: SizedBox.shrink()), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble, size: 25), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: '')
        ],
        currentIndex: _bottomNavigationProvider._currentPage,
        onTap: (index) {
          if (index == 2) {
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyPage()));
          } else {
            _bottomNavigationProvider.setCurrentPage(index);
          }
        },
      ),
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
