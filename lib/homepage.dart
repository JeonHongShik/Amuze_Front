import 'package:amuze/gathercolors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Amuze',
          style: TextStyle(color: PrimaryColors.basic),
        ),
        actions: [
          IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.search,
                color: PrimaryColors.basic,
              ))
        ],
      ),
      body: const Center(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.home,
                  color: SecondColors.basic,
                ),
                onPressed: () => {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: SecondColors.basic,
                ),
                onPressed: () => {},
              ),
            ),
            const Expanded(child: Text('')),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble,
                  color: SecondColors.basic,
                ),
                onPressed: () => {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: SecondColors.basic,
                ),
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColors.basic,
        child: const Icon(
          Icons.menu,
          size: 35,
          color: SecondColors.basic,
        ),
        onPressed: () => (),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
