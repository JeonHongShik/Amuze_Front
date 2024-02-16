import 'package:flutter/material.dart';

import '../gathercolors.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  var switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        backgroundColor: Colors.white,
        title: const Text(
          '알림 설정',
          style: TextStyle(
            color: TextColors.high,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: backColors.disabled, // 임시 (수정필요)
      body: Padding(
        padding: const EdgeInsets.only(
          top: 1,
        ),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 20, 8),
            child: Row(
              children: [
                const Text(
                  '알림 허용',
                  style: TextStyle(
                    color: TextColors.high,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Switch(
                    activeColor: Colors.white,
                    activeTrackColor: PrimaryColors.basic,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFDDDDDD), // 임시 (수정필요)
                    value: switchValue,
                    trackOutlineColor:
                        MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.transparent;
                      }
                      return Colors.transparent; // Use the default color.
                    }),
                    onChanged: (value) {
                      setState(() {
                        switchValue = value;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
