import 'package:amuze/gathercolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SpinKitFadingCube(
          color: PrimaryColors.basic,
          size: 30.0,
        ),
      ),
    );
  }
}
