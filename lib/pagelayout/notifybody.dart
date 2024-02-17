import 'package:amuze/community/community_post.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/server_communication/get/alarm_get_server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotifyBody extends StatefulWidget {
  const NotifyBody({super.key});

  @override
  State<NotifyBody> createState() => _NotifyBodyState();
}

class _NotifyBodyState extends State<NotifyBody> {
  late Future<List<AlarmServerData>> serverData;
  late final uid;
  bool edit = false;

  Future<void> deleteAlarm(int boardId) async {
    final dio = Dio();
    final url = 'http://amuzeback.site/chat/notifications/$boardId/delete/';

    try {
      final response = await dio.delete(
        url,
        data: {'uid': uid},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          serverData = alarmfetchData(uid);
        });
      } else {
        // 요청이 실패한 경우에 대한 처리
        return print('Failed to delete alarm');
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
    }
  }

  Future<void> deleteAlarmAll() async {
    final dio = Dio();
    const url = 'http://amuzeback.site/chat/notification/delete/';

    try {
      final response = await dio.delete(
        url,
        data: {'uid': uid},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          serverData = alarmfetchData(uid);
          edit = !edit;
        });
      } else {
        // 요청이 실패한 경우에 대한 처리
        return print('Failed to delete alarm');
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = alarmfetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<List<AlarmServerData>>(
            future: serverData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('알람 불러오는 중...'),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('알람을 불러오지 못 했습니다.'),
                      const Text('다시 시도'),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: PrimaryColors.basic,
                        ),
                        onPressed: () {
                          setState(() {
                            serverData = alarmfetchData(uid);
                          });
                        },
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          edit == true
                              ? GestureDetector(
                                  onTap: () async {
                                    await deleteAlarmAll();
                                  },
                                  child: const SizedBox(
                                      width: 70,
                                      child: Center(
                                          child: Text(
                                        '전체 삭제',
                                        style:
                                            TextStyle(color: TextColors.medium),
                                      ))),
                                )
                              : const SizedBox.shrink(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                edit = !edit;
                              });
                            },
                            child: SizedBox(
                              width: 50,
                              child: Center(
                                  child: Text(
                                edit == false ? '편집' : '완료',
                                style:
                                    const TextStyle(color: TextColors.medium),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var alarm = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              if (edit == false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommunityPost(
                                        id: int.parse(alarm.boardid!),
                                      ),
                                    ));
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.notifications,
                                        color: SecondaryColors.disabled,
                                      ),
                                      edit == true
                                          ? GestureDetector(
                                              onTap: () async {
                                                await deleteAlarm(alarm.id!);
                                              },
                                              child: const Icon(
                                                Icons.clear,
                                                size: 20,
                                                color: IconColors.inactive,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(alarm.messagebody!),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey[300],
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                );
              } else {
                return const Center(child: Text('알람이 없습니다.'));
              }
            }));
  }
}
