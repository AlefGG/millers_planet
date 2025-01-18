import 'package:flutter/material.dart';
import 'package:millers_planet/main/home_page.dart';
import 'package:millers_planet/resources/ui_themes.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miller\'s Planet',
      theme: UIThemes.darkTheme(),
      home: const HomePage(),
    );
  }
}
