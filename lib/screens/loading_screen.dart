import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          constraints: const BoxConstraints.tightFor(width: 60.0, height: 60.0),
        ),
      ),
    );
  }
}
