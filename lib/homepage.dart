import 'package:amuze/community/community_board.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/pagelayout/chatbody.dart';
import 'package:amuze/pagelayout/homebody.dart';
import 'package:amuze/pagelayout/mypage.dart';
import 'package:amuze/pagelayout/notifybody.dart';
import 'package:amuze/resume/resume_board.dart';
import 'package:flutter/material.dart';
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

  late IconChangeProvider _iconChangeProvider;

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
    _bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);
    _iconChangeProvider = Provider.of<IconChangeProvider>(context);

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColors.basic,
        child: Icon(
          _iconChangeProvider.isDialogOpen ? Icons.close : Icons.menu,
          size: 30,
          color: SecondaryColors.basic,
        ),
        onPressed: () {
          if (_iconChangeProvider.isDialogOpen) {
            Navigator.pop(context);
          } else {
            menuPopup(context);
          }
          _iconChangeProvider.setDialogOpen(!_iconChangeProvider.isDialogOpen);
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}

void menuPopup(context) {
  showDialog(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(70, 0, 70, 0), // dialog 박스 width 조절
        child: Dialog(
          alignment: const Alignment(0.0, 0.7),
          child: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StageBoard()),
                    );
                  },
                  child:
                      // Container(
                      //   width: 60,
                      //   height: 60,
                      //   decoration: BoxDecoration(
                      //       color: Colors.red,
                      //       borderRadius: BorderRadius.circular(50)),
                      // ),
                      const Text(
                    '공고 게시판',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResumeBoard()),
                    );
                  },
                  child: const Text(
                    '이력서 게시판',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CommunityBoard()),
                    );
                  },
                  child: const Text(
                    '커뮤니티 게시판',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    barrierColor: Colors.black26,
  ).then(
    (value) {
      Provider.of<IconChangeProvider>(context, listen: false)
          .setDialogOpen(false);
    },
  );
}
