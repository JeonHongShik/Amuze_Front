import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/resume/resumewrite/resumeregion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResumeGenderAge extends StatefulWidget {
  const ResumeGenderAge({super.key});

  @override
  _ResumeGenderAgeState createState() => _ResumeGenderAgeState();
}

class _ResumeGenderAgeState extends State<ResumeGenderAge> {
  late TextEditingController ageController;
  late TextEditingController genderController;
  late String _selectgender;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController(
        text: Provider.of<ResumeWriteProvider>(context, listen: false).age);
    genderController = TextEditingController(
        text: Provider.of<ResumeWriteProvider>(context, listen: false).gender);
  }

  @override
  void dispose() {
    ageController.dispose();
    genderController.dispose();
    super.dispose();
  }

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
                    TextSpan(text: '     선택해주세요.'),
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
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.male),
                                  title: const Text('남성'),
                                  onTap: () {
                                    _selectgender = '남성';
                                    Provider.of<ResumeWriteProvider>(context,
                                            listen: false)
                                        .setGender('남성');
                                    genderController.text = _selectgender;
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.female),
                                  title: const Text('여성'),
                                  onTap: () {
                                    _selectgender = '여성';
                                    Provider.of<ResumeWriteProvider>(context,
                                            listen: false)
                                        .setGender('여성');
                                    genderController.text = _selectgender;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: AbsorbPointer(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: genderController,
                          maxLines: null,
                          maxLength: null,
                          decoration: const InputDecoration(
                            hintText: '성별',
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.disabled)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.basic)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200, // 하단 시트의 높이를 제한합니다.
                              child: ListView.builder(
                                itemCount: 101,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text('$index살'),
                                    onTap: () {
                                      final age = '$index살';
                                      Provider.of<ResumeWriteProvider>(context,
                                              listen: false)
                                          .setAge(age);
                                      ageController.text = age;
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ),
                            );
                          });
                    },
                    child: AbsorbPointer(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller:
                              ageController, // 여기를 ageController로 변경했습니다.

                          maxLines: null,
                          maxLength: null,
                          decoration: const InputDecoration(
                            hintText: '나이',
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.disabled)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.basic)),
                          ),
                        ),
                      ),
                    ),
                  )
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
            Consumer<ResumeWriteProvider>(builder: (context, provider, child) {
              final bool hasGenderText = provider.gender.isNotEmpty;
              return Consumer<ResumeWriteProvider>(
                builder: (context, provider, child) {
                  final bool hasAgeText = provider.age.isNotEmpty;

                  return ElevatedButton(
                    onPressed: hasGenderText && hasAgeText
                        ? () {
                            //provider 값 체크(추후 이 코드는 삭제)///////////
                            var provider = Provider.of<ResumeWriteProvider>(
                                context,
                                listen: false);

                            print('Title: ${provider.title}');
                            print('Gender: ${provider.gender}');
                            print('Age: ${provider.age}');
                            ///////////////////////////////////////////////
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
              );
            })
          ],
        ),
      ),
    );
  }
}
