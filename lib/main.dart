import 'package:flutter/material.dart';
import 'package:taxi/OTPVerificationScreen.dart';
import 'package:taxi/phoneloginscreen.dart';
import 'package:taxi/sindriver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhoneLoginScreen(),
    );
  }
}
