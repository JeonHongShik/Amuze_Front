import 'package:amuze/gathercolors.dart';
import 'package:amuze/resume/resumewrite/resumeeducation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amuze/main.dart';

class ResumeRegion extends StatefulWidget {
  const ResumeRegion({super.key});

  @override
  _ResumeRegionState createState() => _ResumeRegionState();
}

class _ResumeRegionState extends State<ResumeRegion> {
  late TextEditingController regionController;
  late TextEditingController regionplusController;

  @override
  void initState() {
    super.initState();

    var provider = Provider.of<ResumeWriteProvider>(context, listen: false);
    String firstRegion = provider.regions.isNotEmpty ? provider.regions[0] : '';
    String secondRegion =
        provider.regions.length > 1 ? provider.regions[1] : '';

    regionController = TextEditingController(text: firstRegion);
    regionplusController = TextEditingController(text: secondRegion);
  }

  @override
  void dispose() {
    regionController.dispose();
    regionplusController.dispose();
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
                title: const Text('작성을 취소하고 나가시겠습니까?'),
                actions: [
                  TextButton(
                    child: const Text('아니요'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('예'),
                    onPressed: () {
                      Provider.of<ResumeWriteProvider>(context, listen: false)
                          .reset();
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
                    TextSpan(text: '3. 활동 지역을\n'),
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
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 200, // 하단 시트의 높이를 제한합니다.
                                  child: ListView(
                                    children: [
                                      '서울',
                                      '경기북부',
                                      '경기남부',
                                      '충청남도',
                                      '충청북도',
                                      '전라북도',
                                      '전라남도',
                                      '경상북도',
                                      '경상남도',
                                      '강원도',
                                      '제주도',
                                      '부산',
                                      '대구',
                                      '인천',
                                      '대전·세종',
                                      '광주',
                                      '울산'
                                    ].map((region) {
                                      return ListTile(
                                        title: Text(region),
                                        onTap: () {
                                          regionController.text = region;
                                          var provider =
                                              Provider.of<ResumeWriteProvider>(
                                                  context,
                                                  listen: false);
                                          List<String> updatedRegions =
                                              List<String>.from(
                                                  provider.regions);

                                          if (updatedRegions.isEmpty) {
                                            updatedRegions.add(region);
                                          } else {
                                            updatedRegions[0] = region;
                                          }

                                          provider.setRegions(updatedRegions);

                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: regionController,
                            maxLines: null,
                            maxLength: null,
                            decoration: const InputDecoration(
                              hintText: '활동 지역',
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: PrimaryColors.disabled)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: PrimaryColors.basic)),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 70,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: GestureDetector(
                        onTap: () {
                          final currentContext = context;
                          if (regionController.text.isNotEmpty) {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 200, // 하단 시트의 높이를 제한합니다.
                                    child: ListView(
                                      children: [
                                        '서울',
                                        '경기북부',
                                        '경기남부',
                                        '충청남도',
                                        '충청북도',
                                        '전라북도',
                                        '전라남도',
                                        '경상북도',
                                        '경상남도',
                                        '강원도',
                                        '제주도',
                                        '부산',
                                        '대구',
                                        '인천',
                                        '대전·세종',
                                        '광주',
                                        '울산'
                                      ].map((region) {
                                        return ListTile(
                                          title: Text(region),
                                          onTap: () {
                                            regionplusController.text = region;
                                            var provider = Provider.of<
                                                    ResumeWriteProvider>(
                                                context,
                                                listen: false);
                                            List<String> updatedRegions =
                                                List<String>.from(
                                                    provider.regions);

                                            if (updatedRegions.length < 2) {
                                              updatedRegions.add('');
                                            }
                                            updatedRegions[1] = region;

                                            provider.setRegions(updatedRegions);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('알림'),
                                  content: const Text('첫 번째 활동 지역을 먼저 입력해주세요'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('확인'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: regionplusController,
                            maxLines: null,
                            maxLength: null,
                            decoration: const InputDecoration(
                              hintText: '활동 지역(추가)',
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: PrimaryColors.disabled)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: PrimaryColors.basic)),
                            ),
                          ),
                        ),
                      )),
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
              valueListenable: regionController,
              builder: (context, value, child) {
                final bool hasRegionText = regionController.text.isNotEmpty;

                return ElevatedButton(
                  onPressed: hasRegionText
                      ? () {
                          //provider 값 체크(추후 이 코드는 삭제)///////////
                          var provider = Provider.of<ResumeWriteProvider>(
                              context,
                              listen: false);

                          print('Title: ${provider.title}');
                          print('Gender: ${provider.gender}');
                          print('Age: ${provider.age}');
                          print('Regions : ${provider.regions}');
                          ///////////////////////////////////////////////
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ResumeEducation(),
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
                    backgroundColor: hasRegionText
                        ? PrimaryColors.basic
                        : PrimaryColors.disabled,
                    foregroundColor:
                        hasRegionText ? Colors.white : TextColors.disabled,
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
