import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //최상단 게시판 이동 버튼
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopBoardRowBlank(),
                  TopBoard(
                    label: '공고 게시판',
                    imagePath: null,
                  ),
                  TopBoardRowBlank(),
                  TopBoard(
                    label: '이력서 게시판',
                    imagePath: 'assets/images/이력서_게시판_이미지.png',
                  ),
                  TopBoardRowBlank(),
                  TopBoard(
                    label: '커뮤니티',
                    imagePath: null,
                  ),
                  TopBoardRowBlank()
                ],
              ),
            ),
            const ColumnBlank(),
            const Boards(title: '공고 게시물'),
            const ColumnBlank(),
            const Boards(title: '이력서 게시물'),
            const ColumnBlank(),
            const Boards(title: '커뮤니티'),
          ],
        ),
      ),
    );
  }
}

//최상단 게시판 이동 버튼////////////////////////////////////////////////////////
class TopBoard extends StatelessWidget {
  final String label;
  final String? imagePath;
  const TopBoard({super.key, required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == '공고 게시판') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DummyPage()),
          );
        } else if (label == '이력서 게시판') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DummyPage()),
          );
        } else if (label == '커뮤니티') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DummyPage()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: imagePath != null
                  ? DecorationImage(
                      image: AssetImage(imagePath!), fit: BoxFit.cover)
                  : null,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopBoardRowBlank extends StatelessWidget {
  const TopBoardRowBlank({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.0625,
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

//HomeBody 세로 여백////////////////////////////////////////////////////////////
class ColumnBlank extends StatelessWidget {
  const ColumnBlank({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

//게시판들//////////////////////////////////////////////////////////////////////
class Boards extends StatelessWidget {
  final String title;
  const Boards({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 760,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DummyPage()),
                  ),
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(color: TextColors.high),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////