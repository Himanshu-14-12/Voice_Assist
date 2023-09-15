import 'package:flutter/material.dart';
import 'package:voice_assistant/pattete.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeVA',
      theme: ThemeData.light(
              useMaterial3: true) //Entire app is of the design of material 3
          .copyWith(scaffoldBackgroundColor: Pallete.whiteColor),
      home: const HomePage(),
    );
  }
}
