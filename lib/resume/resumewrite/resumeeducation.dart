import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/resume/resumewrite/resumeawardscompletion.dart';
import 'package:amuze/resume/resumewrite/resumecareers.dart';
import 'package:flutter/material.dart';

class ResumeEducation extends StatefulWidget {
  const ResumeEducation({super.key});

  @override
  _ResumeEducationState createState() => _ResumeEducationState();
}

class _ResumeEducationState extends State<ResumeEducation> {
  final List<Widget> _fields = [];
  final List<TextEditingController> _controllers = [];
  final TextEditingController educationController = TextEditingController();
  final TextEditingController educationplusController = TextEditingController();

  void _addNewField() {
    TextEditingController newController = TextEditingController();
    _controllers.add(newController);
    setState(() {
      _fields.add(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextField(
            controller: newController,
            maxLines: null,
            maxLength: 50,
            decoration: const InputDecoration(
                hintText: '부전공',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 이전 코드를 유지하면서, 맨 아래에 새로운 TextField들(_fields)와 추가 버튼을 추가합니다.
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
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
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
                    TextSpan(text: '4. 학력 및 전공을\n'),
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
                      controller: educationController, // 성별 입력을 위한 컨트롤러 사용
                      maxLines: null,
                      maxLength: 50,
                      decoration: const InputDecoration(
                          hintText: '대표 학력 및 전공',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: educationplusController,
                      maxLines: null,
                      maxLength: 50,
                      decoration: const InputDecoration(
                          hintText: '부전공',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  ..._fields,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: PrimaryColors.basic,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: _addNewField,
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
              valueListenable: educationController,
              builder: (context, value, child) {
                final bool haseducationText =
                    educationController.text.isNotEmpty;

                return ElevatedButton(
                  onPressed: haseducationText
                      ? () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ResumeCareers(),
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
                    backgroundColor: haseducationText
                        ? PrimaryColors.basic
                        : PrimaryColors.disabled,
                    foregroundColor:
                        haseducationText ? Colors.white : TextColors.disabled,
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
