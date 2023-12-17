import 'dart:async';

import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'dart:io';

import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

class ResumePhotos extends StatefulWidget {
  const ResumePhotos({super.key});

  @override
  _ResumePhotosState createState() => _ResumePhotosState();
}

class _ResumePhotosState extends State<ResumePhotos> {
  bool mainLoading = true;

  List<Asset> assetMainImage = [];
  List<File> fileMainImage = [];
  List<Asset> assetOhterImages = [];
  List<File>? fileOtherImages = [];
  //이미 변환된 이미지들의 이름을 저장하는 배열
  List<String> convertedImageNames = [];

  StreamController<List<File>> streamController =
      StreamController<List<File>>();

//메인 이미지 Asset -> File 변경/////////////////////////////////////////////////////////
  Future<List<File>> convertMainImgageAssetToFile(
      List<Asset> assetMainImage) async {
    List<File> tempFiles = [];
    for (Asset asset in assetMainImage) {
      setState(() {
        mainLoading = true;
      });
      File file = await _assetToFile(asset);
      tempFiles.add(file);
    }

    setState(() {
      fileMainImage = tempFiles;
      mainLoading = false;
    });

    return fileMainImage;
  }
//////////////////////////////////////////////////////////////////////////////////////////

//외 이미지들 Asset -> File 변경/////////////////////////////////////////////////////////
  Future<void> convertOtherImagesAssetToFile() async {
    for (Asset asset in assetOhterImages) {
      if (!alreadyConverted((asset))) {
        final file = await _assetToFile(asset);

        setState(() {
          fileOtherImages!.add(file);
          convertedImageNames.add(asset.name);
        });
      }
    }
  }

  bool alreadyConverted(Asset asset) {
    return convertedImageNames.contains(asset.name);
  }

  void deleteImage(Asset image) {
    // 이미지 이름을 convertedImageNames 리스트에서 제거
    convertedImageNames.remove(image.name);
  }
//////////////////////////////////////////////////////////////////////////////////////////

//Asset -> File 변경 함수/////////////////////////////////////////////////////////////////
  Future<File> _assetToFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
////////////////////////////////////////////////////////////////////////////////////////

//test 함수//////////////////////////////////////////////////
  Future<List<File>> loadAndConvertImages() async {
    streamController.add([]);
    final otherImages = await MultiImagePicker.pickImages(
      selectedAssets: assetOhterImages,
      cupertinoOptions: const CupertinoOptions(
        doneButton: UIBarButtonItem(title: 'Confirm'),
        cancelButton: UIBarButtonItem(title: 'Cancel'),
        albumButtonColor: PrimaryColors.basic,
      ),
      materialOptions: const MaterialOptions(
        maxImages: 4,
        enableCamera: true,
        actionBarTitle: "Example App",
        allViewTitle: "All Photos",
        useDetailsView: false,
      ),
    );
    assetOhterImages = otherImages;

    await convertOtherImagesAssetToFile();

    print('이미지 여깄다 : $fileOtherImages');
    streamController.add(fileOtherImages!);

    return fileOtherImages!;
  }
///////////////////////////////////////////////////////////

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
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
      body: SingleChildScrollView(
        child: Center(
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
                      TextSpan(text: '8. 사진을 올려주세요.\n'),
                      TextSpan(
                          text: '       처음 사진이 메인에 올라갑니다.',
                          style: TextStyle(
                              fontSize: 15, color: TextColors.medium)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 30,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('메인 사진(1장)')],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: assetMainImage.isEmpty
                    ? DottedBorder(
                        color: Colors.grey,
                        borderType: BorderType.RRect,
                        dashPattern: const [10, 10],
                        radius: const Radius.circular(30),
                        strokeWidth: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey),
                              child: IconButton(
                                onPressed: () async {
                                  final mainImage =
                                      await MultiImagePicker.pickImages(
                                    selectedAssets: assetMainImage,
                                    cupertinoOptions: const CupertinoOptions(
                                      doneButton:
                                          UIBarButtonItem(title: 'Confirm'),
                                      cancelButton:
                                          UIBarButtonItem(title: 'Cancel'),
                                      albumButtonColor: PrimaryColors.basic,
                                    ),
                                    materialOptions: const MaterialOptions(
                                      maxImages: 1,
                                      enableCamera: true,
                                      actionBarTitle: "Example App",
                                      allViewTitle: "All Photos",
                                      useDetailsView: false,
                                    ),
                                  );
                                  if (mainImage.isNotEmpty) {
                                    assetMainImage.insert(0, mainImage.first);
                                  }
                                  await convertMainImgageAssetToFile(
                                      assetMainImage);
                                },
                                icon: const Icon(Icons.photo_camera),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Stack(children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.transparent,
                                    leading: BackButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    iconTheme: const IconThemeData(
                                        color: PrimaryColors.basic),
                                  ),
                                  extendBodyBehindAppBar: true,
                                  body: PhotoView(
                                    imageProvider: FileImage(fileMainImage[0]),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: mainLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        height: 200.0,
                                        color: Colors.white,
                                      ))
                                  : fileMainImage.isNotEmpty
                                      ? Image(
                                          image: FileImage(fileMainImage[0]),
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                            ),
                          ),
                        ),
                        if (!mainLoading)
                          Positioned(
                            right: 5,
                            top: 5,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red[900]),
                              onPressed: () {
                                setState(() {
                                  assetMainImage.removeAt(0);
                                  fileMainImage.removeAt(0);
                                });
                              },
                            ),
                          ),
                      ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
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
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 30,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('외 사진들(4장까지 선택 가능)')],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  //외 이미지들 들어갈 자리
                  StreamBuilder<List<File>>(
                    stream: streamController.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<File>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return Column(
                          children: snapshot.data!.asMap().entries.map((entry) {
                            int index = entry.key;
                            File file = entry.value;
                            return Center(
                              child: Column(
                                children: [
                                  Stack(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                appBar: AppBar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  leading: BackButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  iconTheme:
                                                      const IconThemeData(
                                                          color: PrimaryColors
                                                              .basic),
                                                ),
                                                extendBodyBehindAppBar: true,
                                                body: PhotoView(
                                                  imageProvider:
                                                      FileImage(file),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Image(
                                                image: FileImage(file),
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.red[900],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              String imageName =
                                                  assetOhterImages[index].name;

                                              // assetOtherImages에서 제거
                                              assetOhterImages.removeAt(index);

                                              // fileOtherImages에서 제거
                                              fileOtherImages!.removeAt(index);

                                              // convertedImageNames에서 제거
                                              convertedImageNames
                                                  .remove(imageName);

                                              // stream에 변환된 이미지 리스트 업데이트
                                              streamController
                                                  .add(fileOtherImages!);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        // 이미지가 로딩 중이면 Shimmer를 표시하고, 모든 이미지가 삭제되었다면 아무것도 표시하지 않음
                        return Container();
                      }
                    },
                  ),
                  if (fileOtherImages!.length < 4)
                    Center(
                      child: DottedBorder(
                        color: Colors.grey,
                        borderType: BorderType.RRect,
                        dashPattern: const [10, 10],
                        radius: const Radius.circular(30),
                        strokeWidth: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.grey),
                                child: IconButton(
                                  onPressed: () async {
                                    //이미지 선택 로직 들어갈 자리

                                    await loadAndConvertImages();
                                  },
                                  icon: const Icon(Icons.photo_camera),
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PrimaryColors.basic,
                foregroundColor: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
              ),
              child: const Text(
                '등록',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
