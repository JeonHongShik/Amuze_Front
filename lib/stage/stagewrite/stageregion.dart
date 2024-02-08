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
  late TextEditingController regionController = TextEditingController();

  List<String> korearegions = [
    '전국',
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '세종',
    '경기도',
    '강원도',
    '충청북도',
    '충청남도',
    '전라북도',
    '전라남도',
    '경산북도',
    '경산남도',
    '제주도',
  ];

  List<String> subseoul = [
    '전체',
    '강남구',
    '강동구',
    '강북구',
    '강서구',
    '관악구',
    '광진구',
    '구로구',
    '금천구',
    '노원구',
    '도봉구',
    '동대문구',
    '동작구',
    '마포구',
    '서대문구',
    '서초구',
    '성동구',
    '성북구',
    '양천구',
    '영등포구',
    '용산구',
    '은평구',
    '종로구',
    '중구',
    '중량구',
  ];

  List<String> subbusan = [
    '중구',
    '서구',
    '동구',
    '영도구',
    '부산진구',
    '동래구',
    '남구',
    '북구',
    '강서구',
    '해운대구',
    '사하구',
    '금정구',
    '연제구',
    '수영구',
    '사상구',
    '기장군'
  ];

  List<String> subdaegu = [
    '중구',
    '동구',
    '서구',
    '남구',
    '북구',
    '수성구',
    '달서구',
    '달성군',
    '군위군'
  ];

  List<String> subincheon = [
    '중구',
    '동구',
    '미추홀구',
    '연수구',
    '남동구',
    '부평구',
    '계양구',
    '서구',
    '강화군',
    '웅진군'
  ];

  List<String> subgwangju = ['동구', '서구', '남구', '북구', '광산구'];
  List<String> subdaejeon = ['동구', '중구', '서구', '유성구', '대덕구'];
  List<String> subulsan = ['중구', '남구', '동구', '북구', '울주군'];
  List<String> subgyeonggi = [
    '수원시 장안구',
    '수원시 권선구',
    '수원시 팔달구',
    '수원시 영통구',
    '성남시 수정구',
    '성남시 증원구',
    '성남시 분당구',
    '의정부시',
    '안양시 만안구',
    '안양시 동안구',
    '부천시 원미구',
    '부천시 소사구',
    '부천시 오정구',
    '광명시',
    '동두천시',
    '평택시',
    '안산시 상록구',
    '안산시 단원구',
    '고양시 덕양구',
    '고양시 일산동구',
    '고양시 일산서구',
    '과천시',
    '구리시',
    '남양주시',
    '오산시',
    '시흥시',
    '군포시',
    '의왕시',
    '하남시',
    '용인시 처인구',
    '용인시 기흥구',
    '용인시 수지구',
    '파주시',
    '이천시',
    '안성시',
    '김포시',
    '화성시',
    '광주시',
    '양주시',
    '포천시',
    '여주시',
    '연천군',
    '가평군',
    '양평군'
  ];

  List<String> subgangwon = [
    '춘천시',
    '원주시',
    '강릉시',
    '동해시',
    '태백시',
    '속초시',
    '삼척시',
    '홍천군',
    '횡성군',
    '영월군',
    '평창군',
    '정선군',
    '철원군',
    '화천군',
    '양구군',
    '인제군',
    '고성군',
    '양양군'
  ];

  List<String> subchungbuk = [
    '청주시 상당구',
    '청주시 흥덕구',
    '청주시 서원구',
    '청주시 청원구',
    '충주시',
    '제천시',
    '보은군',
    '옥천군',
    '영동군',
    '증평군',
    '진천군',
    '괴산군',
    '음성군',
    '단양군'
  ];

  List<String> subchungnam = [
    '천안시 동남구',
    '천안시 서북구',
    '공주시',
    '보령시',
    '아산시',
    '서산시',
    '논산시',
    '계룡시',
    '당진시',
    '금산군',
    '부여군',
    '서천군',
    '청양군',
    '홍성군',
    '예산군',
    '태안군'
  ];

  List<String> subjeonbuk = [
    '전주시 완산구',
    '전주시 덕진구',
    '군산시',
    '익산시',
    '정읍시',
    '남원시',
    '김제시',
    '완주군',
    '진안군',
    '무주군',
    '장수군',
    '임실군',
    '순창군',
    '고창군',
    '부안군'
  ];

  List<String> subjeonnam = [
    '목포시',
    '여수시',
    '순천시',
    '나주시',
    '광양시',
    '담양군',
    '곡성군',
    '구례군',
    '고흥군',
    '보성군',
    '화순군',
    '장흥군',
    '강진군',
    '해남군',
    '영암군',
    '무안군',
    '함평군',
    '영광군',
    '장성군',
    '완도군',
    '진도군',
    '신안군'
  ];

  List<String> subgyeongbuk = [
    '포항시 남구',
    '포항시 북구',
    '경주시',
    '김천시',
    '안동시',
    '구미시',
    '영주시',
    '영천시',
    '상주시',
    '문경시',
    '경산시',
    '의성군',
    '청송군',
    '영양군',
    '영덕군',
    '청도군',
    '고령군',
    '성주군',
    '칠곡군',
    '예천군',
    '봉화군',
    '울진군',
    '울릉군'
  ];

  List<String> subgyeongnam = [
    '창원시 의창구',
    '창원시 성산구',
    '창원시 마산합포구',
    '창원시 마산회원구',
    '창원시 진해구',
    '진주시',
    '통영시',
    '사천시',
    '김해시',
    '밀양시',
    '거제시',
    '양산시',
    '의령군',
    '함안군',
    '창녕군',
    '고성군',
    '남해군',
    '하동군',
    '산청군',
    '함양군',
    '거창군',
    '합천군'
  ];

  List<String> subjeju = ['제주시', '서귀포시'];

  void _showSubRegionModal(
      BuildContext context, String mainRegion, List<String> subRegions) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: ListView(
            children: subRegions.map((subRegion) {
              return ListTile(
                title: Text(subRegion),
                onTap: () {
                  String selectedRegion = '$mainRegion $subRegion';
                  _updateRegionSelection(selectedRegion);
                  Navigator.pop(context); // 현재 하단 시트 닫기
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateRegionSelection(String selectedRegion) {
    regionController.text = selectedRegion;
    var provider = Provider.of<StageWriteProvider>(context, listen: false);
    String updatedRegions = provider.region;

    updatedRegions = selectedRegion;

    provider.setRegion(updatedRegions);
    Navigator.pop(context); // 첫 번째 하단 시트 닫기
  }

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<StageWriteProvider>(context, listen: false);

    regionController = TextEditingController(text: provider.region);
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
                          Provider.of<StageWriteProvider>(context,
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
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 400, // 하단 시트의 높이를 제한합니다.
                                  child: ListView(
                                    children: korearegions.map((region) {
                                      return ListTile(
                                        title: Text(region),
                                        onTap: () {
                                          regionbottomsheet(region, context);
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
                              hintText: '공연 지역',
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

  void regionbottomsheet(String region, BuildContext context) {
    switch (region) {
      case '서울':
        _showSubRegionModal(context, '서울', subseoul);
        break;
      case '부산':
        _showSubRegionModal(context, '부산', subbusan);
        break;
      case '대구':
        _showSubRegionModal(context, '대구', subdaegu);
        break;
      case '인천':
        _showSubRegionModal(context, '인천', subincheon);
        break;
      case '광주':
        _showSubRegionModal(context, '광주', subgwangju);
        break;
      case '대전':
        _showSubRegionModal(context, '대전', subdaejeon);
        break;
      case '울산':
        _showSubRegionModal(context, '울산', subulsan);
        break;
      case '경기도':
        _showSubRegionModal(context, '경기도', subgyeonggi);
        break;
      case '강원도':
        _showSubRegionModal(context, '강원도', subgangwon);
        break;
      case '충청북도':
        _showSubRegionModal(context, '충청북도', subchungbuk);
        break;
      case '충청남도':
        _showSubRegionModal(context, '충청남도', subchungnam);
        break;
      case '전라북도':
        _showSubRegionModal(context, '전라북도', subjeonbuk);
        break;
      case '전라남도':
        _showSubRegionModal(context, '전라남도', subjeonnam);
        break;
      case '경상북도':
        _showSubRegionModal(context, '경상북도', subgyeongbuk);
        break;
      case '경상남도':
        _showSubRegionModal(context, '경상남도', subgyeongnam);
        break;
      case '제주도':
        _showSubRegionModal(context, '제주도', subjeju);
        break;
      default:
        _updateRegionSelection(region);
    }
  }
}
