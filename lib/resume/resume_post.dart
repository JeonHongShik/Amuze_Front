import 'package:flutter/material.dart';

class StagePost extends StatefulWidget {
  const StagePost({super.key});

  @override
  State<StagePost> createState() => _StagePostState();
}

class _StagePostState extends State<StagePost> {
  late ScrollController _scrollController;
  double _containerTop = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _containerTop = _scrollController.offset;
        double maxScrollOffset = MediaQuery.of(context).size.height / 3 / 2;
        if (_containerTop > maxScrollOffset) {
          _containerTop = maxScrollOffset;
          _scrollController.jumpTo(maxScrollOffset);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: imageHeight,
            child: Transform.scale(
              scale: 1 + _containerTop * 0.001,
              child: Image.asset(
                'assets/images/김채원.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Container(
              color: Colors.transparent.withOpacity(_containerTop * 0.003),
            ),
          ),
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView(
              controller: _scrollController,
              //padding에서 상수로 15 빼는 방법 말고, 다른 방법 있는지 연구
              padding: EdgeInsets.only(top: imageHeight - 15),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
