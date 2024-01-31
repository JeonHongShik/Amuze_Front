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

  @override
  void initState() {
    super.initState();
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
              // Amuze 로고

              // children: [
              //   const Text(
              //     'Amuze',
              //     style: TextStyle(
              //       color: Colors.white,
              //       // color: PrimaryColors.basic,
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   const SizedBox(height: 10),

              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.82,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextField(
                          controller: controller,
                          focusNode: searchFocus,
                          cursorColor: TextColors.medium,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 18, 0, 8),
                            hintText: '공고 게시물을 검색해보세요!\n',
                            hintStyle:
                                const TextStyle(color: TextColors.medium),
                            border: InputBorder.none,
                            suffix: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                              child: GestureDetector(
                                onTap: () => controller.clear(),
                                child: const Icon(
                                  Icons.cancel,
                                  color: IconColors.disabled,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
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
                      icon: const Icon(
                        Icons.search,
                      ),
                      color: Colors.white,
                      iconSize: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
