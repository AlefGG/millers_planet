import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:millers_planet/main/model/card_model.dart';
import 'package:millers_planet/resources/ui_themes.dart';
import 'package:millers_planet/src/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondPageView extends StatefulWidget {
  final VoidCallback onButtonPressed;

  const SecondPageView({super.key, required this.onButtonPressed});

  @override
  State<SecondPageView> createState() => _SecondPageViewState();
}

class _SecondPageViewState extends State<SecondPageView>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;
  late Timer _timer;
  late DateTime _currentDateTime;
  String _dateTimeOnEarth = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _iconController,
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

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Slide and fade animations for the first text
    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 1), // Start from below
      end: Offset.zero, // Move to the original position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slide and fade animations for the second text (delayed)
    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward(); // Start animations
  }

  @override
  void dispose() {
    _iconController.dispose();
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
                                  _iconController.stop();
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
                      SlideTransition(
                        position: _slideAnimation1,
                        child: FadeTransition(
                          opacity: _fadeAnimation1,
                          child: Text(
                            'On Miller\'s planet, 1 second equals 61320 seconds on Earth—around 17 hours and 2 minutes.',
                            style: theme.largeTitleThin64,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SlideTransition(
                        position: _slideAnimation2,
                        child: FadeTransition(
                          opacity: _fadeAnimation2,
                          child: Column(
                            children: [
                              Text(
                                'If you had spent all the time since Interstellar\'s release on Miller\'s planet, the current Earth date would be:',
                                style: theme.largeTitle48,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _dateTimeOnEarth,
                                style: theme.largeTitleThin64
                                    .copyWith(fontSize: 80),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
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
            color: Colors.black,
            child: Center(
              child: InkWell(
                onTap: () {
                  _launchURL();
                },
                child: SvgPicture.asset(
                  'assets/icons/github.svg',
                  height: 40,
                  colorFilter: ColorFilter.mode(
                    theme.greyPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
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

    final earthDays = (remainingMilliseconds ~/ millisecondsInDay);
    final remainingMillisecondsInDay =
        remainingMilliseconds % millisecondsInDay;

    final earthHours = (remainingMillisecondsInDay ~/ millisecondsInHour);

    return '$earthYears  year, ${earthDays < 10 ? '0$earthDays' : earthDays} day, ${earthHours < 10 ? '0$earthHours' : earthHours} hour';
  }

  Future<void> _launchURL() async {
    final url = Uri.parse('https://github.com/AlefGG/millers_planet');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
