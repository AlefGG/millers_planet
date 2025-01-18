import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:millers_planet/main/home_page.dart';
import 'package:millers_planet/resources/ui_themes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await precacheAssets();
  FlutterNativeSplash.remove();

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

Future<void> precacheAssets() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  binding.addPostFrameCallback((_) async {
    final BuildContext? context = binding.rootElement;
    if (context == null) {
      print('Context is null');
      return;
    }

    await precacheImage(
      const AssetImage('assets/images/planet.jpg'),
      context,
    );
  });
}
