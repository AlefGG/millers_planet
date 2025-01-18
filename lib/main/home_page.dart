import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:millers_planet/main/widgets/expandable_page_view.dart';
import 'package:millers_planet/main/widgets/first_page_view.dart';
import 'package:millers_planet/main/widgets/second_page_view.dart';
import 'package:millers_planet/main/widgets/transparent_image.dart';
import 'package:millers_planet/resources/ui_themes.dart';
import 'package:millers_planet/src/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  double _backgroundOffset = 0.0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );

    _pageController.addListener(() {
      setState(() {
        _backgroundOffset = _pageController.page ?? 0.0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, -1 * _backgroundOffset * 50),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: const AssetImage('assets/images/planet.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          PageView.builder(
            itemCount: 2,
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return FirstPageView(
                    onButtonPressed: () {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                case 1:
                  return SecondPageView(
                    onButtonPressed: () {
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
