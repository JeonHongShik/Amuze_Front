import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/resume/resume_post.dart';
import 'package:amuze/resume/resumewrite/resumetitle.dart';
import 'package:amuze/stage/stagewrite/stagetitle.dart';
import 'package:flutter/material.dart';

class StageBoard extends StatelessWidget {
  const StageBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        title: const Text(
          '공고 게시판',
          style: TextStyle(color: PrimaryColors.basic),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DummyPage(),
                  )),
              icon: const Icon(
                Icons.search,
                size: 30,
                color: PrimaryColors.basic,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 17),
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '전체 100',
                  style: TextStyle(color: TextColors.medium),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Stagetitle(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text(
                      '공고 작성하기',
                      style: TextStyle(color: TextColors.high),
                    ))
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                      [for (var i = 0; i < 15; i++) const DummyContainer()]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DummyContainer extends StatelessWidget {
  const DummyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey))),
    );
  }
}
