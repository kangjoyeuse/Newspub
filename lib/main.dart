import 'package:flutter/material.dart';
import 'package:newspub/screen/onboarding_screen.dart';
import 'package:newspub/screen/splash_screen.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

