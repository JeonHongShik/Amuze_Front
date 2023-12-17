import 'package:amuze/gathercolors.dart';
import 'package:amuze/resume/resumewrite/resumeregion.dart';
import 'package:flutter/material.dart';

class ResumeGenderAge extends StatefulWidget {
  const ResumeGenderAge({super.key});

  @override
  _ResumeGenderAgeState createState() => _ResumeGenderAgeState();
}

class _ResumeGenderAgeState extends State<ResumeGenderAge> {
  final TextEditingController genderController =
      TextEditingController(); // 성별 입력을 위한 컨트롤러
  final TextEditingController ageController =
      TextEditingController(); // 나이 입력을 위한 컨트롤러

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
                text: const TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(text: '2. 성별과 나이를\n'),
                    TextSpan(text: '     입력해주세요.'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: genderController, // 성별 입력을 위한 컨트롤러 사용
                      maxLines: null,
                      maxLength: 50,
                      decoration: const InputDecoration(
                          hintText: '성별',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: ageController, // 나이 입력을 위한 컨트롤러 사용
                      maxLines: null,
                      maxLength: 50,
                      decoration: const InputDecoration(
                          hintText: '나이',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          // Row 위젯을 추가합니다.
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
              valueListenable: genderController,
              builder: (context, value, child) {
                final bool hasGenderText = genderController.text.isNotEmpty;
                final bool hasAgeText = ageController.text.isNotEmpty;

                return ElevatedButton(
                  onPressed: hasGenderText && hasAgeText
                      ? () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ResumeRegion(),
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
                    backgroundColor: hasGenderText && hasAgeText
                        ? PrimaryColors.basic
                        : PrimaryColors.disabled,
                    foregroundColor: hasGenderText && hasAgeText
                        ? Colors.white
                        : TextColors.disabled,
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
