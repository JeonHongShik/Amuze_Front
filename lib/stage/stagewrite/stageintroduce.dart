import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/resume/resumewrite/resumegenderage.dart';
import 'package:amuze/resume/resumewrite/resumephotos.dart';
import 'package:amuze/stage/stagewrite/stagephotos.dart';

import 'package:flutter/material.dart';

class StageIntroduce extends StatefulWidget {
  const StageIntroduce({super.key});

  @override
  _StageIntroduceState createState() => _StageIntroduceState();
}

class _StageIntroduceState extends State<StageIntroduce> {
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
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
      body: SingleChildScrollView(
        child: Center(
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
                      TextSpan(text: '7. 공연에 대해\n'),
                      TextSpan(text: '     작성해주세요.'),
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: TextField(
                      controller: controller,
                      maxLines: 15,
                      maxLength: 3000,
                      decoration: const InputDecoration(
                          hintText: '공연에 대해 알려주세요.',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 이전 페이지로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    PrimaryColors.basic, // 배경색을 PrimaryColors.basic으로 설정
                foregroundColor: Colors.white, // 전경색을 Colors.white로 설정
                minimumSize: Size(MediaQuery.of(context).size.width * 0.3, 50),
              ),
              child: const Text(
                '이전',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ValueListenableBuilder(
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
                                      const StagePhotos(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                    foregroundColor:
                        hasText ? Colors.white : TextColors.disabled,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.5, 50),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
