import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../service/member.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
