import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'PhoneLoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // بدون DefaultFirebaseOptions
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi App',
      debugShowCheckedModeBanner: false,
      home: const PhoneLoginScreen(),
    );
  }
}
