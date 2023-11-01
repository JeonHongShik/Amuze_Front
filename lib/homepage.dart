import 'package:amuze/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈페이지'),
      ),
      body: Center(
          child: Column(
        children: [
          userInfo.profile != null
              ? SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.network('${userInfo.profile}'),
                )
              : Container(),
          Text('kakaoid : ${userInfo.kakaoid}'),
          Text('name : ${userInfo.name}'),
        ],
      )),
      bottomNavigationBar: const BottomAppBar(),
    );
  }
}
