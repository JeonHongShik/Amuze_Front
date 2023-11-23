import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/chatbody.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/pagelayout/homebody.dart';
import 'package:amuze/pagelayout/mypage.dart';
import 'package:amuze/pagelayout/notifybody.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  late BottomNavigationProvider _bottomNavigationProvider;

  @override
  Widget build(BuildContext context) {
    _bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Amuze',
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
        child: const Icon(
          Icons.menu,
          size: 30,
          color: SecondaryColors.basic,
        ),
        onPressed: () => (),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
