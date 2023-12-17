import 'package:amuze/gathercolors.dart';
import 'package:amuze/resume/resumewrite/resumegenderage.dart';
import 'package:amuze/stage/stagewrite/stageregion.dart';

import 'package:flutter/material.dart';

class Stagetitle extends StatefulWidget {
  const Stagetitle({super.key});

  @override
  _StagetitleState createState() => _StagetitleState();
}

class _StagetitleState extends State<Stagetitle> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: PrimaryColors.basic,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('작성을 취소하고 나가시겠습니까?'),
                actions: [
                  TextButton(
                    child: const Text('아니요'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('예'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: RichText(
                // 이 부분을 변경했습니다.
                text: const TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(text: '1. 게시물 제목을\n'),
                    TextSpan(text: '     입력해주세요.'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  maxLength: 50,
                  decoration: const InputDecoration(
                      hintText: '제목을 입력하세요.',
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: PrimaryColors.disabled)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: PrimaryColors.basic))),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            final bool hasText = controller.text.isNotEmpty;

            return ElevatedButton(
              onPressed: hasText
                  ? () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const StageRegion(),
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
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasText ? PrimaryColors.basic : PrimaryColors.disabled,
                foregroundColor: hasText ? Colors.white : TextColors.disabled,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 18),
              ),
            );
          },
        ),
      ),
    );
  }
}
