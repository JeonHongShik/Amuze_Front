import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.blue,
          size: 50.0,
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }
}
