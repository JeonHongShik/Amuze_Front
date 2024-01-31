import 'package:amuze/gathercolors.dart';
import 'package:amuze/stage/stagewrite/stageintroduce.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amuze/main.dart';
import 'package:provider/provider.dart';

class StageDeadlineDate extends StatefulWidget {
  const StageDeadlineDate({super.key});

  @override
  _StageDeadlineDateState createState() => _StageDeadlineDateState();
}

class _StageDeadlineDateState extends State<StageDeadlineDate> {
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StageWriteProvider>(context, listen: false);
    deadlineController.text = provider.deadline;
    dateController.text = provider.date;
    timeController.text = provider.time;
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<StageWriteProvider>(context,
                                  listen: false)
                              .reset();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
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
                      const SizedBox(width: 10),
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
                      TextSpan(text: '6. 공고 마감일과 공연 날짜를\n'),
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
                        controller: deadlineController, // 성별 입력을 위한 컨트롤러 사용
                        maxLines: null,
                        maxLength: null,
                        readOnly: true,
                        decoration: const InputDecoration(
                            hintText: '공고 마감일',
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.disabled)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.basic))),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: PrimaryColors
                                          .basic, // header background color

                                      onPrimary:
                                          Colors.black, // header text color
                                      onSurface:
                                          Colors.black, // body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.black // button text color
                                          ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              });

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              deadlineController.text = formattedDate;
                              Provider.of<StageWriteProvider>(context,
                                      listen: false)
                                  .setDeadline(formattedDate);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: dateController, // 나이 입력을 위한 컨트롤러 사용
                        maxLines: null,
                        maxLength: null,
                        readOnly: true,
                        decoration: const InputDecoration(
                            hintText: '공연 날짜',
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.disabled)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.basic))),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: PrimaryColors
                                          .basic, // header background color
                                      onPrimary:
                                          Colors.black, // header text color
                                      onSurface:
                                          Colors.black, // body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.black // button text color
                                          ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              });

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate;
                              Provider.of<StageWriteProvider>(context,
                                      listen: false)
                                  .setDate(formattedDate);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: timeController,
                        maxLines: null,
                        maxLength: null,
                        readOnly: true,
                        decoration: const InputDecoration(
                            hintText: '공연 시간',
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.disabled)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: PrimaryColors.basic))),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                        // change the border color
                                        primary: PrimaryColors.basic,
                                        // change the text color
                                        onSurface: Colors.black,
                                        onBackground: Colors.black),
                                    // button colors
                                    buttonTheme: const ButtonThemeData(
                                      colorScheme: ColorScheme.light(
                                        primary: PrimaryColors.basic,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                ),
                              );
                            },
                          );

                          if (pickedTime != null) {
                            String formattedTime =
                                '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                            setState(() {
                              timeController.text = formattedTime;
                              Provider.of<StageWriteProvider>(context,
                                      listen: false)
                                  .setTime(formattedTime);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              valueListenable: deadlineController,
              builder: (context, value, child) {
                final bool hasDeadlineText = deadlineController.text.isNotEmpty;
                final bool hasDateText = dateController.text.isNotEmpty;

                return ElevatedButton(
                  onPressed: hasDeadlineText && hasDateText
                      ? () {
                          //provider 값 체크(추후 이 코드는 삭제)///////////
                          var provider = Provider.of<StageWriteProvider>(
                              context,
                              listen: false);

                          print('Title: ${provider.title}');
                          print('Region: ${provider.region}');
                          print('type: ${provider.type}');
                          print('wishtype: ${provider.wishtype}');
                          print('pay: ${provider.pay}');
                          print('Deadline: ${provider.deadline}');
                          print('Date: ${provider.date}');
                          print('time: ${provider.time}');
                          print('Datetime: ${provider.datetime}');
                          ///////////////////////////////////////////////
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const StageIntroduce(),
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
                    backgroundColor: hasDeadlineText && hasDateText
                        ? PrimaryColors.basic
                        : PrimaryColors.disabled,
                    foregroundColor: hasDeadlineText && hasDateText
                        ? Colors.white
                        : TextColors.disabled,
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
