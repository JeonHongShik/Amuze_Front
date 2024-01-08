import 'package:flutter/material.dart';

import '../gathercolors.dart';

class CommentManagement extends StatefulWidget {
  const CommentManagement({super.key});

  @override
  State<CommentManagement> createState() => _CommentManagementState();
}

class _CommentManagementState extends State<CommentManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        backgroundColor: Colors.white,
        title: const Text(
          '댓글 관리',
          style: TextStyle(
            color: TextColors.high,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
