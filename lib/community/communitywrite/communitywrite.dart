import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Communitywrite extends StatefulWidget {
  const Communitywrite({super.key});

  @override
  State<Communitywrite> createState() => _CommunitywriteState();
}

class _CommunitywriteState extends State<Communitywrite> {
  late TextEditingController titleController; // 게시물 제목 컨트롤러
  late TextEditingController contentController; // 게시물 내용 컨트롤러

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    // text:
    // Provider.of<CommunityWriteProvider>(context, listen: false).title
    contentController = TextEditingController();
    // text: Provider.of<CommunityWriteProvider>(context, listen: false)
    //     .content);
  }

  // @override
  // void dispose() {
  //   titleController.dispose();
  //   contentController.dispose();
  //   super.dispose();
  // }

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "게시물을 작성해주세요!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    controller: titleController, // 게시물 제목 입력 컨트롤러
                    maxLength: 50,
                    decoration: const InputDecoration(
                        hintText: '게시물 제목을 입력하세요.',
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: PrimaryColors.disabled)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: PrimaryColors.basic))),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: TextField(
                      controller: contentController, // 게시물 내용 입력 컨트롤러
                      maxLines: 15,
                      maxLength: 3000,
                      decoration: InputDecoration(
                        hintText: '게시물 내용을 입력하세요.',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: PrimaryColors.disabled),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: PrimaryColors.basic),
                        ),
                      ),
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
        child: ValueListenableBuilder(
          valueListenable: titleController,
          builder: (context, value, child) {
            final bool hasTitleText = titleController.text.isNotEmpty;
            final bool hasContentText = contentController.text.isNotEmpty;

            return ElevatedButton(
              onPressed: hasTitleText && hasContentText
                  ? () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const DummyPage(),
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
                  backgroundColor: hasTitleText && hasContentText
                      ? PrimaryColors.basic
                      : PrimaryColors.disabled,
                  foregroundColor: hasTitleText && hasContentText
                      ? Colors.white
                      : TextColors.disabled,
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                '등록',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}
