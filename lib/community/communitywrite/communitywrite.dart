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
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    final communityWriteProvider =
        Provider.of<CommunityWriteProvider>(context, listen: false);
    communityWriteProvider.author = userInfoProvider.uid;
    titleController = TextEditingController(text: communityWriteProvider.title);
    contentController =
        TextEditingController(text: communityWriteProvider.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
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
                  '게시물 작성을 취소하시겠습니까?',
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
                          Provider.of<CommunityWriteProvider>(context,
                                  listen: false)
                              .reset();
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
                    onChanged: (text) {
                      Provider.of<CommunityWriteProvider>(context,
                              listen: false)
                          .setTitle(text);
                    },
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
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: TextField(
                      controller: contentController, // 게시물 내용 입력 컨트롤러
                      onChanged: (text) {
                        Provider.of<CommunityWriteProvider>(context,
                                listen: false)
                            .setContent(text);
                      },
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
                  ? () async {
                      ////////////////////////////////////////////////////////

                      var provider = Provider.of<CommunityWriteProvider>(
                          context,
                          listen: false);

                      print(provider.author);
                      print('author : ${provider.author}');
                      print('Title : ${provider.title}');
                      print('Content : ${provider.content}');
                      ////////////////////////////////////////////////////////

                      // 데이터 전송
                      Future<void> response;
                      if (provider.id == null) {
                        response = provider.postCommunityData();
                      } else {
                        response = provider.patchCommunityData();
                      }

                      // 응답 처리
                      await response.then((_) {
                        provider.reset();
                        Navigator.of(context).pop();

                        // 게시물 등록 성공 알림창
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            title: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: const Text(
                                '게시물이 정상적으로 등록되었습니다!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: TextColors.high,
                                ),
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: PrimaryColors.basic,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Text(
                                        '확인',
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
                      }).catchError((error) {
                        print('//////////////////Error sending data: $error');
                      });
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
