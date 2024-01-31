import 'package:amuze/gathercolors.dart';
import 'package:amuze/resume/resumewrite/resumeintroduce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amuze/main.dart';

class ResumeAwardsCompletions extends StatefulWidget {
  const ResumeAwardsCompletions({super.key});

  @override
  _ResumeAwardsCompletionsState createState() =>
      _ResumeAwardsCompletionsState();
}

class _ResumeAwardsCompletionsState extends State<ResumeAwardsCompletions> {
  final List<Widget> _awardsfields = [];
  final List<Widget> _completionsfields = [];
  final List<TextEditingController> _awardscontrollers = [];
  final List<TextEditingController> _completionscontrollers = [];
  final TextEditingController awardController = TextEditingController();
  final TextEditingController completionController = TextEditingController();

  void _addNewawardsField() {
    TextEditingController newController = TextEditingController();
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);
    _awardscontrollers.add(newController);
    setState(() {
      _awardsfields.add(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextField(
            controller: newController,
            maxLines: null,
            maxLength: 50,
            onChanged: (value) {
              int index = _awardscontrollers.indexOf(newController) + 1;

              if (value.isEmpty) {
                // 값이 비어있으면 해당 위치의 항목 제거
                if (index < resumeWriteProvider.awards.length) {
                  resumeWriteProvider.awards.removeAt(index);
                }
              } else {
                // 리스트의 길이가 인덱스보다 작다면, 리스트를 확장
                while (resumeWriteProvider.awards.length <= index) {
                  resumeWriteProvider.awards.add('');
                }

                // 새로운 값을 적절한 위치에 저장
                resumeWriteProvider.awards[index] = value;
              }
            },
            decoration: const InputDecoration(
                hintText: '수상',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
          ),
        ),
      );
    });
  }

  void _addNewcompletionsField() {
    TextEditingController newController = TextEditingController();
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);
    _completionscontrollers.add(newController);
    setState(() {
      _completionsfields.add(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextField(
            controller: newController,
            maxLines: null,
            maxLength: 50,
            onChanged: (value) {
              int index = _completionscontrollers.indexOf(newController) + 1;

              if (value.isEmpty) {
                // 값이 비어있으면 해당 위치의 항목 제거
                if (index < resumeWriteProvider.completions.length) {
                  resumeWriteProvider.completions.removeAt(index);
                }
              } else {
                // 리스트의 길이가 인덱스보다 작다면, 리스트를 확장
                while (resumeWriteProvider.completions.length <= index) {
                  resumeWriteProvider.completions.add('');
                }

                // 새로운 값을 적절한 위치에 저장
                resumeWriteProvider.completions[index] = value;
              }
            },
            decoration: const InputDecoration(
                hintText: '수료',
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
  void initState() {
    super.initState();
    final resumeWriteProvider =
        Provider.of<ResumeWriteProvider>(context, listen: false);

    if (resumeWriteProvider.awards.isNotEmpty) {
      awardController.text = resumeWriteProvider.awards[0];
    }

    if (resumeWriteProvider.completions.isNotEmpty) {
      completionController.text = resumeWriteProvider.completions[0];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final width = MediaQuery.of(context).size.width;
        // 세 번째 값부터 시작하여 추가 TextField 생성
        for (int i = 1; i < resumeWriteProvider.awards.length; i++) {
          _addAwardsExistingField(resumeWriteProvider.awards[i], i, width);
        }
      }

      if (mounted) {
        final width = MediaQuery.of(context).size.width;
        // 세 번째 값부터 시작하여 추가 TextField 생성
        for (int i = 1; i < resumeWriteProvider.completions.length; i++) {
          _addCompletionsExistingField(
              resumeWriteProvider.completions[i], i, width);
        }
      }
    });
  }

  void _addAwardsExistingField(String initialValue, int index, double width) {
    TextEditingController newController =
        TextEditingController(text: initialValue);
    _awardscontrollers.add(newController);
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
          int index =
              _awardscontrollers.indexOf(newController) + 1; // 인덱스 2부터 시작

          if (value.isEmpty) {
            // 값이 비어있으면 해당 위치의 항목 제거
            if (index < resumeWriteProvider.awards.length) {
              resumeWriteProvider.awards.removeAt(index);
            }
          } else {
            // 리스트의 길이가 인덱스보다 작다면, 리스트를 확장
            while (resumeWriteProvider.awards.length <= index) {
              resumeWriteProvider.awards.add('');
            }

            // 새로운 값을 적절한 위치에 저장
            resumeWriteProvider.awards[index] = value;
          }
        },
        decoration: const InputDecoration(
          hintText: '수상',
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
      _awardsfields.insert(index - 1, newField); // +버튼 위에 삽입
    });
  }

  void _addCompletionsExistingField(
      String initialValue, int index, double width) {
    TextEditingController newController =
        TextEditingController(text: initialValue);
    _completionscontrollers.add(newController);
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
          int index =
              _completionscontrollers.indexOf(newController) + 1; // 인덱스 2부터 시작

          if (value.isEmpty) {
            // 값이 비어있으면 해당 위치의 항목 제거
            if (index < resumeWriteProvider.completions.length) {
              resumeWriteProvider.completions.removeAt(index);
            }
          } else {
            // 리스트의 길이가 인덱스보다 작다면, 리스트를 확장
            while (resumeWriteProvider.completions.length <= index) {
              resumeWriteProvider.completions.add('');
            }

            // 새로운 값을 적절한 위치에 저장
            resumeWriteProvider.completions[index] = value;
          }
        },
        decoration: const InputDecoration(
          hintText: '수료',
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
      _completionsfields.insert(index - 1, newField); // +버튼 위에 삽입
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
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: const Text(
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: backColors.disabled,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: TextColors.high,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.33,
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
                    TextSpan(text: '6. 수상 및 수료 사항을\n'),
                    TextSpan(text: '      입력해주세요.'),
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
                      controller: awardController, // 수상 입력을 위한 컨트롤러 사용
                      maxLines: null,
                      maxLength: 50,
                      onChanged: (value) {
                        if (value.isEmpty &&
                            resumeWriteProvider.awards.isNotEmpty) {
                          resumeWriteProvider.awards.removeAt(0); // 수상 제거
                        } else {
                          if (resumeWriteProvider.awards.isNotEmpty) {
                            resumeWriteProvider.awards[0] = value; // 수상 업데이트
                          } else {
                            resumeWriteProvider.awards.add(value); // 수상 추가
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: '수상',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  ..._awardsfields,
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
                      onPressed: _addNewawardsField,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
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
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: completionController,
                      maxLines: null,
                      maxLength: 50,
                      onChanged: (value) {
                        // 값이 비어있고, 리스트에 해당 인덱스가 존재하는 경우
                        if (value.isEmpty &&
                            resumeWriteProvider.completions.length > 1) {
                          resumeWriteProvider.completions.removeAt(0);
                        } else if (value.isNotEmpty) {
                          // 값이 있을 때의 처리
                          if (resumeWriteProvider.completions.length > 1) {
                            resumeWriteProvider.completions[0] =
                                value; // 부전공 업데이트
                          } else {
                            resumeWriteProvider.completions
                                .add(value); // 부전공 추가
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: '수료',
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.disabled)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrimaryColors.basic))),
                    ),
                  ),
                  ..._completionsfields,
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
                      onPressed: _addNewcompletionsField,
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
                print('Educations : ${provider.educations}');
                print('Careers : ${provider.careers}');
                print('Awards : ${provider.awards}');
                print('Completions : ${provider.completions}');
                ///////////////////////////////////////////////
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ResumeIntroduce(),
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
