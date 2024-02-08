import 'package:amuze/gathercolors.dart';

import 'package:amuze/main.dart';
import 'package:amuze/server_communication/get/detail/stage_detail_get_server.dart';
import 'package:amuze/stage/stagewrite/stagetitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import 'package:photo_view/photo_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class StagePost extends StatefulWidget {
  final int? id;

  const StagePost({super.key, this.id});

  @override
  State<StagePost> createState() => _StagePostState();
}

class _StagePostState extends State<StagePost> {
  final dio = Dio();
  late ScrollController _scrollController;
  double _containerTop = 0;

  late Future<List<StageDetailServerData>> serverData;
  List<String?> imageList = [];

  bool bookmarked = false;
  int bookmarkId = 0;
  bool ready = true;

  String displayName = '';
  String photoURL = '';

  bool chat = false;

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다이얼로그 외부 터치로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: const Text(
            '정말 게시물을 삭제하시겠습니까?',
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
              '게시물 삭제 시, 게시물을 복구할 수 없습니다.',
              textAlign: TextAlign.center,
            ),
          ),
          contentTextStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: TextColors.high,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
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
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: backColors.disabled,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '삭제하기',
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
                      '취소',
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
        );
      },
    );
  }

  Future<bool> _deletePost() async {
    try {
      final response = await dio.delete(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/posts/post/delete/${widget.id.toString()}/',
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

  Future<void> _checkBookmarked() async {
    try {
      final provider = Provider.of<UserInfoProvider>(context, listen: false);
      final response = await dio.get(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/bookmarks/bookmark/post/check/${provider.uid}/${widget.id.toString()}/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          bookmarked = response.data['bookmark'];
          bookmarkId = response.data['id'];
        });
        print('/////////////////////////////$bookmarked');
        print('/////////////////////////////$bookmarkId');
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  void _toggleBookmarked() async {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    if (bookmarked == false) {
      try {
        final response = await dio.post(
            'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/bookmarks/bookmark/post/',
            data: {'uid': provider.uid, 'post': widget.id});
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            bookmarked = true;
            bookmarkId = response.data['id'];
            ready = true;
          });
          print('//////////////////////$bookmarkId');
        }
      } catch (e) {
        print('postError : $e');
      }
    } else if (bookmarked == true) {
      try {
        final response = await dio.delete(
            'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/bookmarks/bookmark/post/delete/$bookmarkId/',
            data: {'uid': provider.uid});
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            bookmarked = !bookmarked;
            ready = true;
          });
        }
      } catch (e) {
        print('deletError : $e');
      }
    }
  }

  Future<void> fetchUserProfile(String author) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(author)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          photoURL = userData['photoURL'];
          displayName = userData['displayName'];
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    serverData = stagedetailfetchData(widget.id!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _containerTop = _scrollController.offset;
      });
    });
    _checkBookmarked();
    serverData.then((data) {
      if (data.isNotEmpty) {
        fetchUserProfile(data.first.author!);
      }
    });
    print(widget.id);
    print(Provider.of<UserInfoProvider>(context, listen: false).uid);
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            scrolledUnderElevation: 0,
            expandedHeight: imageHeight,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                bool isExpanded = constraints.biggest.height > kToolbarHeight;
                return FlexibleSpaceBar(
                  background: isExpanded
                      ? FutureBuilder<List<StageDetailServerData>>(
                          future: serverData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              var item = snapshot.data!.first;
                              List<String?> imagePaths = [
                                item.mainimage,
                                item.otherimages1,
                                item.otherimages2,
                                item.otherimages3,
                                item.otherimages4,
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
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: SizedBox.shrink());
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
              ),
              child: FutureBuilder<List<StageDetailServerData>>(
                future: serverData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        const SpinKitFadingCube(
                          color: PrimaryColors.basic,
                          size: 30.0,
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        chat = true;
                      });
                    });
                    return Column(
                      children: snapshot.data!.map((item) {
                        var children2 = <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 첫 12글자 표시
                                    Text(
                                      item.title!.length > 14
                                          ? item.title!.substring(0, 14)
                                          : item.title!,
                                      style: const TextStyle(fontSize: 21),
                                    ),
                                    // customIcons 표시
                                    customIcons(item, context),
                                  ],
                                ),
                                // 12글자를 초과하는 경우 나머지 텍스트 표시
                                if (item.title!.length > 14)
                                  Text(
                                    item.title!.substring(14),
                                    style: const TextStyle(fontSize: 21),
                                  ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    if (photoURL.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            25), // 이미지를 원형으로 만들기 위한 경계 반지름
                                        child: Image.network(
                                          photoURL,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        displayName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          buildNullableInfo('원하는 무용 종류', item.wishtype),
                          const postmargin(),
                          buildNullableInfo('무대 종류', item.type),
                          const postmargin(),
                          buildNullableInfo('공연 일시', item.datetime),
                          const postmargin(),
                          buildNullableInfo('공고 마감기한', item.deadline),
                          const postmargin(),
                          buildNullableregionInfo('위치', item.region),
                          const postmargin(),
                          paybuildNullableInfo('페이', item.pay),
                          const postmargin(),
                          buildNullableInfo('공연 정보', item.introduce),
                        ];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children2,
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // 컬럼 내용을 중앙에 정렬
                        children: [
                          const Text('게시물을 불러오지 못 했습니다.'),
                          IconButton(
                            icon: const Icon(Icons.arrow_back), // 뒤로 가기 아이콘
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // 현재 화면을 닫고 이전 화면으로 돌아감
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: chat == true
          ? Padding(
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
            )
          : const SizedBox.shrink(),
    );
  }

  Widget customIcons(StageDetailServerData item, BuildContext context) {
    return item.author ==
            Provider.of<UserInfoProvider>(context, listen: false).uid
        ? Row(
            children: [
              IconButton(
                  onPressed: () async {
                    final stageprovider =
                        Provider.of<StageWriteProvider>(context, listen: false);
                    if (item.id != null) {
                      stageprovider.id = item.id;
                    }
                    if (item.title != null && item.title != '') {
                      stageprovider.setTitle(item.title!);
                    }
                    if (item.region != null && item.region != '') {
                      stageprovider.setRegion(item.region!);
                    }
                    if (item.type != null && item.type != '') {
                      stageprovider.setType(item.type!);
                    }
                    if (item.type != null && item.type != '') {
                      stageprovider.setType(item.type!);
                    }

                    if (item.wishtype != null && item.wishtype != '') {
                      stageprovider.setWishtype(item.wishtype!);
                    }
                    if (item.pay != null && item.pay != '') {
                      stageprovider.setPay(item.pay!);
                    }
                    if (item.deadline != null && item.deadline != '') {
                      stageprovider.setDeadline(item.deadline!);
                    }
                    if (item.datetime != null && item.datetime != '') {
                      stageprovider.setDatetime(item.datetime!);
                      stageprovider.splitDateAndTimeAsync();
                    }
                    if (item.introduce != null && item.introduce != '') {
                      stageprovider.setIntroduce(item.introduce!);
                    }
                    if (item.mainimage != null) {
                      String fullImageUrl =
                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.mainimage!}';
                      ImageItem mainImageItem =
                          ImageItem.fromPath(fullImageUrl);
                      stageprovider.setFileMainimage([mainImageItem]);
                    }

                    List<ImageItem> otherImages = [];

                    if (item.otherimages1 != null) {
                      String fullImageUrl =
                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimages1!}';
                      ImageItem imageItem = ImageItem.fromPath(fullImageUrl);
                      otherImages.add(imageItem);
                    }
                    if (item.otherimages2 != null) {
                      String fullImageUrl =
                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimages2!}';
                      ImageItem imageItem = ImageItem.fromPath(fullImageUrl);
                      otherImages.add(imageItem);
                    }
                    if (item.otherimages3 != null) {
                      String fullImageUrl =
                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimages3!}';
                      ImageItem imageItem = ImageItem.fromPath(fullImageUrl);
                      otherImages.add(imageItem);
                    }
                    if (item.otherimages4 != null) {
                      String fullImageUrl =
                          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${item.otherimages4!}';
                      ImageItem imageItem = ImageItem.fromPath(fullImageUrl);
                      otherImages.add(imageItem);
                    }

                    stageprovider.setFileOtherimages(otherImages);

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const Stagetitle(),
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
                    ).then((_) {
                      setState(() {
                        serverData = stagedetailfetchData(widget.id!);
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: IconColors.inactive,
                  )),
              IconButton(
                  onPressed: () async {
                    await _showDeleteDialog(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: IconColors.inactive,
                  )),
            ],
          )
        : IconButton(
            onPressed: () {
              if (ready == true) {
                setState(() {
                  ready = false;
                });
                _toggleBookmarked();
              }
            },
            icon: Icon(
              bookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: SecondaryColors.basic,
              size: 30,
            ),
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class postmargin extends StatelessWidget {
  const postmargin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
    );
  }
}

Widget buildNullableInfo(String label, String? value) {
  return value != null && value.isNotEmpty
      ? Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 10), // 하단 패딩 조정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: TextColors.medium, fontSize: 15),
              ),
              Text(
                value,
                style: const TextStyle(color: TextColors.high, fontSize: 18),
                overflow: TextOverflow.visible, // 오버플로우 처리 변경
                softWrap: true, // 자동 줄바꿈 활성화
              )
            ],
          ),
        )
      : const SizedBox.shrink();
}

Widget paybuildNullableInfo(String label, String? value) {
  // 숫자 형식을 확인하고 3자리마다 콤마를 추가합니다.
  final formattedValue = value != null && value.isNotEmpty
      ? NumberFormat('#,###').format(int.tryParse(value) ?? 0)
      : null;

  return formattedValue != null
      ? Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 10), // 하단 패딩 조정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: TextColors.medium, fontSize: 15),
              ),
              Text(
                '$formattedValue원', // 형식이 지정된 값 사용
                style: const TextStyle(color: TextColors.high, fontSize: 18),
                overflow: TextOverflow.visible, // 오버플로우 처리 변경
                softWrap: true, // 자동 줄바꿈 활성화
              )
            ],
          ),
        )
      : const SizedBox.shrink();
}

Widget buildNullableregionInfo(String label, String? value) {
  return value != null && value.isNotEmpty
      ? Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 10), // 하단 패딩 조정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: TextColors.medium, fontSize: 15),
              ),
              Text(
                value,
                style: const TextStyle(color: TextColors.high, fontSize: 18),
                overflow: TextOverflow.visible, // 오버플로우 처리 변경
                softWrap: true, // 자동 줄바꿈 활성화
              ),
              const Text(
                '자세한 위치는 채팅을 통해 물어보세요!',
                style: TextStyle(color: TextColors.disabled, fontSize: 12),
              ),
            ],
          ),
        )
      : const SizedBox.shrink();
}
