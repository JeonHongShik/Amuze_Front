import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/resume/resumewrite/resumetitle.dart';
import 'package:amuze/server_communication/get/resume_detail_get_server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import 'package:photo_view/photo_view.dart';

class ResumePost extends StatefulWidget {
  final int? id;

  const ResumePost({super.key, this.id});

  @override
  State<ResumePost> createState() => _ResumePostState();
}

class _ResumePostState extends State<ResumePost> {
  final dio = Dio();
  late ScrollController _scrollController;
  double _containerTop = 0;

  late Future<List<ResumeDetailServerData>> serverData;
  List<String?> imageList = [];

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다이얼로그 외부 터치로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정말 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () async {
                // 2. 확인 버튼 누를 시 삭제 요청 보내기
                final bool success = await _deletePost(); // 게시물 삭제 함수 호출

                if (success) {
                  // 삭제 성공 시
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop();
                } else {
                  // 삭제 실패 시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('삭제에 실패했습니다.'),
                    ),
                  );
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deletePost() async {
    try {
      final response = await dio.delete(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/resumes/resume/delete/${widget.id.toString()}/',
          data: {
            'uid': Provider.of<UserInfoProvider>(context, listen: false).uid
          }
          // 필요한 헤더 및 인증 정보를 추가할 수 있음
          );

      if (response.statusCode == 200) {
        // 삭제 요청이 성공적으로 처리될 때
        return true;
      } else {
        // 삭제 요청이 실패할 때
        return false;
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    serverData = resumedetailfetchData(widget.id!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _containerTop = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //int currentPageIndex = 0;
    double imageHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                bool isExpanded = constraints.biggest.height > kToolbarHeight;
                return FlexibleSpaceBar(
                  background: isExpanded
                      ? FutureBuilder<List<ResumeDetailServerData>>(
                          future: serverData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text('이미지를 가져오는 중입니다'),
                              );
                            }
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              var item = snapshot.data!.first;
                              List<String?> imagePaths = [
                                item.mainimage,
                                item.otherimage1,
                                item.otherimage2,
                                item.otherimage3,
                                item.otherimage4,
                              ].where((path) => path != null).toList();

                              if (imagePaths.isEmpty) {
                                // 이미지가 없는 경우 기본 이미지 표시
                                return Image.asset('assets/images/김채원.jpg',
                                    fit: BoxFit.cover);
                              } else {
                                return PageView.builder(
                                  itemCount: imagePaths.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                            appBar: AppBar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              leading:
                                                  BackButton(onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                              iconTheme: const IconThemeData(
                                                  color: PrimaryColors.basic),
                                            ),
                                            extendBodyBehindAppBar: true,
                                            body: PhotoViewGallery.builder(
                                              itemCount: imagePaths.length,
                                              builder: (context, index) {
                                                return PhotoViewGalleryPageOptions(
                                                  imageProvider: NetworkImage(
                                                      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${imagePaths[index]}'),
                                                  minScale:
                                                      PhotoViewComputedScale
                                                          .contained,
                                                  maxScale:
                                                      PhotoViewComputedScale
                                                              .contained *
                                                          2,
                                                );
                                              },
                                              scrollPhysics:
                                                  const BouncingScrollPhysics(),
                                              backgroundDecoration:
                                                  const BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              pageController: PageController(
                                                  initialPage: index),
                                              enableRotation: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Image.network(
                                        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${imagePaths[index]}',
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              return Image.asset('assets/images/김채원.jpg',
                                  fit: BoxFit.cover);
                            }
                          },
                        )
                      : Container(
                          color: Colors.grey.shade300,
                        ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.circular(15),
              ),
              child: FutureBuilder<List<ResumeDetailServerData>>(
                future: serverData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((item) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${item.title}',
                                          style: const TextStyle(fontSize: 25),
                                          maxLines: 2,
                                        ),
                                        if (item.author ==
                                            Provider.of<UserInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .displayName)
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    final resumeprovider = Provider
                                                        .of<ResumeWriteProvider>(
                                                            context,
                                                            listen: false);
                                                    if (item.id != null) {
                                                      resumeprovider.id =
                                                          item.id.toString();
                                                    }
                                                    if (item.title != null) {
                                                      resumeprovider.setTitle(
                                                          item.title!);
                                                    }
                                                    if (item.title != null) {
                                                      resumeprovider.setTitle(
                                                          item.title!);
                                                    }
                                                    if (item.gender != null) {
                                                      resumeprovider.setGender(
                                                          item.gender!);
                                                    }
                                                    if (item.age != null) {
                                                      resumeprovider
                                                          .setAge(item.age!);
                                                    }
                                                    if (item.regions != null) {
                                                      resumeprovider.setRegions(
                                                          item.regions!);
                                                    }
                                                    if (item.educations !=
                                                        null) {
                                                      resumeprovider
                                                          .setEducations(
                                                              item.educations!);
                                                    }
                                                    if (item.careers != null) {
                                                      resumeprovider.setCareers(
                                                          item.careers!);
                                                    }
                                                    if (item.awards != null) {
                                                      resumeprovider.setAwards(
                                                          item.awards!);
                                                    }
                                                    if (item.completions !=
                                                        null) {
                                                      resumeprovider
                                                          .setCompletions(item
                                                              .completions!);
                                                    }
                                                    if (item.introduce !=
                                                        null) {
                                                      resumeprovider
                                                          .setIntroduce(
                                                              item.introduce!);
                                                    }
                                                    if (item.mainimage !=
                                                        null) {
                                                      String fullImageUrl =
                                                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.mainimage!}';
                                                      ImageItem mainImageItem =
                                                          ImageItem.fromPath(
                                                              fullImageUrl);
                                                      resumeprovider
                                                          .setFileMainimage(
                                                              [mainImageItem]);
                                                    }

                                                    List<ImageItem>
                                                        otherImages = [];

                                                    if (item.otherimage1 !=
                                                        null) {
                                                      String fullImageUrl =
                                                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimage1!}';
                                                      ImageItem imageItem =
                                                          ImageItem.fromPath(
                                                              fullImageUrl);
                                                      otherImages
                                                          .add(imageItem);
                                                    }
                                                    if (item.otherimage2 !=
                                                        null) {
                                                      String fullImageUrl =
                                                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimage2!}';
                                                      ImageItem imageItem =
                                                          ImageItem.fromPath(
                                                              fullImageUrl);
                                                      otherImages
                                                          .add(imageItem);
                                                    }
                                                    if (item.otherimage3 !=
                                                        null) {
                                                      String fullImageUrl =
                                                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimage3!}';
                                                      ImageItem imageItem =
                                                          ImageItem.fromPath(
                                                              fullImageUrl);
                                                      otherImages
                                                          .add(imageItem);
                                                    }
                                                    if (item.otherimage4 !=
                                                        null) {
                                                      String fullImageUrl =
                                                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimage4!}';
                                                      ImageItem imageItem =
                                                          ImageItem.fromPath(
                                                              fullImageUrl);
                                                      otherImages
                                                          .add(imageItem);
                                                    }

                                                    resumeprovider
                                                        .setFileOtherimages(
                                                            otherImages);
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            const Resumetitle(),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          var begin =
                                                              const Offset(
                                                                  1.0, 0.0);
                                                          var end = Offset.zero;
                                                          var tween = Tween(
                                                              begin: begin,
                                                              end: end);
                                                          var offsetAnimation =
                                                              animation
                                                                  .drive(tween);

                                                          return SlideTransition(
                                                            position:
                                                                offsetAnimation,
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    ).then((_) {
                                                      setState(() {
                                                        serverData =
                                                            resumedetailfetchData(
                                                                widget.id!);
                                                      });
                                                    });
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  onPressed: () async {
                                                    await _showDeleteDialog(
                                                        context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: IconColors.inactive,
                                                  )),
                                            ],
                                          )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child:
                                            Text(item.author ?? 'No Author')),
                                  ],
                                )),
                            buildNullableInfo('나이', item.age),
                            buildNullableInfo('성별', item.gender),
                            listNullableInfo('학력', item.educations),
                            listNullableInfo('활동지역', item.regions),
                            listNullableInfo('경력', item.careers),
                            listNullableInfo('수상', item.awards),
                            listNullableInfo('수료', item.completions),
                            buildNullableInfo('자기소개서', item.introduce),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(child: Text('No Data Available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: PrimaryColors.basic,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
          ),
          child: const Text(
            '채팅',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

Widget buildNullableInfo(String label, String? value) {
  return value != null && value.isNotEmpty
      ? Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
          child: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      const TextStyle(color: TextColors.medium, fontSize: 15),
                ),
                Text(
                  value,
                  style: const TextStyle(color: TextColors.high, fontSize: 18),
                )
              ],
            ),
          ),
        )
      : const SizedBox.shrink();
}

Widget listNullableInfo(String label, List<String>? value) {
  if (value == null || value.isEmpty) {
    return const SizedBox.shrink(); // 비어있는 경우 아무것도 표시하지 않음
  }

  return Container(
    margin: const EdgeInsets.only(left: 20),
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: TextColors.medium, fontSize: 15),
        ),
        ...value.map((item) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                item,
                style: const TextStyle(color: TextColors.high, fontSize: 18),
              ),
            )),
      ],
    ),
  );
}
