import 'package:amuze/search/stage_board_searchresult.dart';
import 'package:flutter/material.dart';

import '../gathercolors.dart';

class StageBoardSearch extends StatefulWidget {
  const StageBoardSearch({super.key});

  @override
  State<StageBoardSearch> createState() => _StageBoardSearchState();
}

class _StageBoardSearchState extends State<StageBoardSearch> {
  final TextEditingController controller = TextEditingController();
  FocusNode searchFocus = FocusNode();
  final String labelText = '';
  bool isIconVisible = false;

  void deleteEvent(String value) {
    controller.text = value;

    if (value.isEmpty) {
      isIconVisible = false;
    } else {
      isIconVisible = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColors.disabled,
      appBar: AppBar(
        toolbarHeight: 110,
        leadingWidth: MediaQuery.of(context).size.width,
        backgroundColor: PrimaryColors.basic,
        // backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뒤로가기 버튼
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              // 검색바, 검색버튼
              Padding(
                // 검색바 container 패딩 - container 위치 조정
                padding: const EdgeInsets.fromLTRB(15, 0, 9, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.82,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              // textfield 감싸는 패딩 - textfiled 텍스트 위치 조정
                              padding: const EdgeInsets.fromLTRB(14, 2, 0, 0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.68,
                                height: 35,
                                child: TextField(
                                  controller: controller,
                                  focusNode: searchFocus,
                                  cursorColor: TextColors.medium,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: '공고 게시물을 검색해보세요!',
                                    hintStyle:
                                        TextStyle(color: TextColors.medium),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, value, child) {
                                  return Positioned(
                                    right: 0,
                                    child: value.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              controller.clear();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 7.5, 9, 7.5),
                                              child: Icon(
                                                Icons.cancel,
                                                color: IconColors.disabled,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  );
                                }),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (controller.text.isNotEmpty) {
                              late String searchtext = controller.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StageBoardSearchResult(
                                    searchtext: searchtext,
                                  ),
                                ),
                              );
                            }
                            print('검색어 : ${controller.text}');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
