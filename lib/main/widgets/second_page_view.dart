import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:millers_planet/main/model/card_model.dart';
import 'package:millers_planet/resources/ui_themes.dart';
import 'package:millers_planet/src/constants.dart';

class SecondPageView extends StatefulWidget {
  final VoidCallback onButtonPressed;

  const SecondPageView({super.key, required this.onButtonPressed});

  @override
  State<SecondPageView> createState() => _SecondPageViewState();
}

class _SecondPageViewState extends State<SecondPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  late DateTime _currentDateTime;
  String _dateTimeOnEarth = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _currentDateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
        _dateTimeOnEarth = calculateTimeOnEarthIfAllThisTimeOnMillersPlanet();
        // print(_currentDateTime);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animation.value),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  widget.onButtonPressed();
                                  _controller.stop();
                                },
                                borderRadius: BorderRadius.circular(90),
                                child: const Icon(
                                  Icons.arrow_upward_sharp,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1 second passes for 61320 seconds on Miller\'s planet, or 17 hours and 2 minutes',
                        style: theme.largeTitleThin64,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'If you\'d spent all this time since Interstellar\'s release on Miller\'s planet, on Earth it would be',
                        style: theme.largeTitle48,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        _dateTimeOnEarth,
                        style: theme.largeTitleThin64.copyWith(fontSize: 80),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            height: 50,
            color: theme.greyPrimary,
          ),
        )
      ],
    );
  }

//calculate what time it would be on Earth if all this time passed on Miller's planet
  String calculateTimeOnEarthIfAllThisTimeOnMillersPlanet() {
    final millisecondsPassed = _currentDateTime
        .difference(Constants.interstellarReleaseDate)
        .inMilliseconds;
    final earthMilliseconds = millisecondsPassed * 61320;

    const millisecondsInYear = 365.25 * 24 * 60 * 60 * 1000;
    const millisecondsInDay = 24 * 60 * 60 * 1000;
    const millisecondsInHour = 60 * 60 * 1000;

    final earthYears =
        (earthMilliseconds ~/ millisecondsInYear) + DateTime.now().year;
    final remainingMilliseconds = earthMilliseconds % millisecondsInYear;

    final earthDays =
        (remainingMilliseconds ~/ millisecondsInDay) + DateTime.now().day;
    final remainingMillisecondsInDay =
        remainingMilliseconds % millisecondsInDay;

    final earthHours = (remainingMillisecondsInDay ~/ millisecondsInHour) +
        DateTime.now().hour;

    return '$earthYears  years, ${earthDays < 10 ? '0$earthDays' : earthDays} days, ${earthHours < 10 ? '0$earthHours' : earthHours} hours';
  }
}

enum CardType { first, second, third }

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    super.key,
    required this.cardType,
    required this.text,
    required this.imagePath,
  });

  final CardType cardType;
  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.greyPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (cardType == CardType.first && imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              // color: Colors.yellow,
              // constraints: const BoxConstraints(
              //   maxHeight: 200,
              // ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                text ?? '',
                style: theme.text24Regular
                    .copyWith(color: theme.textPrimary, height: 1),
              ),
            ),
          ),
          if (cardType == CardType.third && imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              // color: Colors.yellow,
              // constraints: const BoxConstraints(
              //   maxHeight: 200,
              // ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
        ],
      ),
    );
  }
}
