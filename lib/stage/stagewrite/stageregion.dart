import 'package:amuze/gathercolors.dart';
import 'package:amuze/stage/stagewrite/stagetype.dart';
import 'package:flutter/material.dart';
import 'package:amuze/main.dart';
import 'package:provider/provider.dart';

class StageRegion extends StatefulWidget {
  const StageRegion({super.key});

  @override
  _StageRegionState createState() => _StageRegionState();
}

class _StageRegionState extends State<StageRegion> {
  final TextEditingController regionController =
      TextEditingController(); // 성별 입력을 위한 컨트롤러

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
                      Provider.of<StageWriteProvider>(context, listen: false)
                          .reset();
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
                    TextSpan(text: '2. 공연 지역을 \n'),
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
                      controller: TextEditingController(
                          text: Provider.of<StageWriteProvider>(context,
                                  listen: false)
                              .region),
                      onChanged: (text) {
                        Provider.of<StageWriteProvider>(context, listen: false)
                            .setRegion(text);
                      },
                      maxLines: null,
                      maxLength: null,
                      decoration: const InputDecoration(
                          hintText: '공연 지역',
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
            Consumer<StageWriteProvider>(
              builder: (context, provider, child) {
                final bool hasRegionText = provider.region.isNotEmpty;

                return ElevatedButton(
                  onPressed: hasRegionText
                      ? () {
                          //provider 값 체크(추후 이 코드는 삭제)///////////
                          var provider = Provider.of<StageWriteProvider>(
                              context,
                              listen: false);

                          print('Title: ${provider.title}');
                          print('Region: ${provider.region}');
                          ///////////////////////////////////////////////
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const StageType(),
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
