import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dummy Page'),
      ),
      body: const Center(
        child: Text('This is a dummy page.'),
      ),
    );
  }
}
