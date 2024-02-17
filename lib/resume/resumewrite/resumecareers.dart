import 'package:amuze/gathercolors.dart';
import 'package:amuze/resume/resumewrite/resumeawardscompletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amuze/main.dart';

class ResumeCareers extends StatefulWidget {
  const ResumeCareers({super.key});

  @override
  _ResumeCareersState createState() => _ResumeCareersState();
}

class _ResumeCareersState extends State<ResumeCareers> {
  final List<Widget> _fields = [];
  final List<TextEditingController> _controllers = [];
  final TextEditingController careerController = TextEditingController();
  final TextEditingController careerplusController = TextEditingController();

  void _addNewField() {
    TextEditingController newController = TextEditingController();
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);
    _controllers.add(newController);
    setState(() {
      _fields.add(
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: newController,
                maxLines: null,
                maxLength: 50,
                onChanged: (value) {
                  int index =
                      _controllers.indexOf(newController) + 2; // 인덱스 2부터 시작

                  if (value.isEmpty) {
                    // 값이 비어있으면 해당 위치의 항목 제거
                    if (index < resumeWriteProvider.careers.length) {
                      resumeWriteProvider.careers.removeAt(index);
                    }
                  } else {
                    // 리스트의 길이가 인덱스보다 작다면, 리스트를 확장
                    while (resumeWriteProvider.careers.length <= index) {
                      resumeWriteProvider.careers.add('');
                    }

                    // 새로운 값을 적절한 위치에 저장
                    resumeWriteProvider.careers[index] = value;
                  }
                },
                decoration: const InputDecoration(
                    hintText: '경력',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);

    // 첫 번째와 두 번째 값이 있는 경우, 이들을 각각의 컨트롤러에 할당
    if (resumeWriteProvider.careers.isNotEmpty) {
      careerController.text = resumeWriteProvider.careers[0];
      if (resumeWriteProvider.careers.length > 1) {
        careerplusController.text = resumeWriteProvider.careers[1];
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final width = MediaQuery.of(context).size.width;
        // 세 번째 값부터 시작하여 추가 TextField 생성
        for (int i = 2; i < resumeWriteProvider.careers.length; i++) {
          _addExistingField(resumeWriteProvider.careers[i], i, width);
        }
      }
    });
  }

  void _addExistingField(String initialValue, int index, double width) {
    TextEditingController newController =
        TextEditingController(text: initialValue);
    _controllers.add(newController);
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);

    Widget newField = SizedBox(
      width: width * 0.75,
      child: TextField(
        //focusNode: newFocusNode,
        controller: newController,
        maxLines: null,
        maxLength: 50,
        onChanged: (value) {
          int index = _controllers.indexOf(newController) + 2; // 인덱스 2부터 시작

          if (value.isEmpty) {
            // 값이 비어있으면 해당 위치의 항목 제거
            if (index < resumeWriteProvider.careers.length) {
              resumeWriteProvider.careers.removeAt(index);
            }
          } else {
            // 리스트의 길이가 인덱스보다 작다면, 리스트를 확장
            while (resumeWriteProvider.careers.length <= index) {
              resumeWriteProvider.careers.add('');
            }

            // 새로운 값을 적절한 위치에 저장
            resumeWriteProvider.careers[index] = value;
          }
        },
        decoration: const InputDecoration(
          hintText: '부전공',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );

    setState(() {
      _fields.insert(index - 2, newField); // +버튼 위에 삽입
    });
  }

  @override
  Widget build(BuildContext context) {
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);
    return Scaffold(
      // 이전 코드를 유지하면서, 맨 아래에 새로운 TextField들(_fields)와 추가 버튼을 추가합니다.
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                title: const Text(
                  '이력서 작성을 취소하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high,
                  ),
                ),
                content: const SizedBox(
                  width: 280,
                  child: Text(
                    '취소 시, 작성하신 내용은 저장되지 않습니다.',
                    textAlign: TextAlign.center,
                  ),
                ),
                contentTextStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: TextColors.high,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<ResumeWriteProvider>(context,
                                  listen: false)
                              .reset();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 125,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: backColors.disabled,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '나가기',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: TextColors.high,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 125,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: PrimaryColors.basic,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text(
                            '계속 작성하기',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    TextSpan(text: '5. 경력을\n'),
                    TextSpan(text: '     입력해주세요.'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                '예시)  OO무용단 출신,  OO무용학원 운영',
                style: TextStyle(
                  fontSize: 14,
                  color: TextColors.disabled,
                  fontWeight: FontWeight.w500,
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
                      controller: careerController, // 성별 입력을 위한 컨트롤러 사용
                      maxLines: null,
                      maxLength: 50,
                      onChanged: (value) {
                        if (value.isEmpty &&
                            resumeWriteProvider.careers.isNotEmpty) {
                          resumeWriteProvider.careers.removeAt(0); // 경력 제거
                        } else {
                          if (resumeWriteProvider.careers.isNotEmpty) {
                            resumeWriteProvider.careers[0] = value; // 경력 업데이트
                          } else {
                            resumeWriteProvider.careers.add(value); // 경력 추가
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: '경력',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: careerplusController,
                      maxLines: null,
                      maxLength: 50,
                      onChanged: (value) {
                        // 값이 비어있고, 리스트에 해당 인덱스가 존재하는 경우
                        if (value.isEmpty &&
                            resumeWriteProvider.careers.length > 1) {
                          resumeWriteProvider.careers.removeAt(1);
                        } else if (value.isNotEmpty) {
                          // 값이 있을 때의 처리
                          if (resumeWriteProvider.careers.length > 1) {
                            resumeWriteProvider.careers[1] = value; // 부전공 업데이트
                          } else {
                            resumeWriteProvider.careers.add(value); // 부전공 추가
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: '경력',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
            ElevatedButton(
              onPressed: () {
                //provider 값 체크(추후 이 코드는 삭제)///////////
                var provider =
                    Provider.of<ResumeWriteProvider>(context, listen: false);

                print('Title: ${provider.title}');
                print('Gender: ${provider.gender}');
                print('Age: ${provider.age}');
                print('Regions : ${provider.regions}');
                print('Regions : ${provider.educations}');
                print('Regions : ${provider.careers}');
                ///////////////////////////////////////////////
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ResumeAwardsCompletions(),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: PrimaryColors.basic,
                foregroundColor: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
