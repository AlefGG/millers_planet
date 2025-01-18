import 'dart:async';

import 'package:flutter/material.dart';
import 'package:millers_planet/resources/ui_themes.dart';
import 'package:millers_planet/src/constants.dart';

class FirstPageView extends StatefulWidget {
  final VoidCallback onButtonPressed;

  const FirstPageView({super.key, required this.onButtonPressed});

  @override
  State<FirstPageView> createState() => _FirstPageViewState();
}

class _FirstPageViewState extends State<FirstPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  late DateTime _currentDateTime;

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
    final earthMicrosecondsSinceDate = microsecondsSinceData(
        _currentDateTime, Constants.interstellarReleaseDate);
    final earthMicrosecondsInSevenYears = microsecondeInSevenYears();
    final millersMicrosecondsSinceDate =
        earthMicrosecondsSinceDate / earthMicrosecondsInSevenYears;
    final formattedMillersMicrosecondsSinceDate =
        formatMillersDateTimeSinceRelease(
      millersMicrosecondsSinceDate,
    );

    final theme = UIThemes.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.05),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox.shrink(),
            // const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formattedMillersMicrosecondsSinceDate
                      .toString()
                      .split(' ')
                      .last
                      .substring(
                          0,
                          formattedMillersMicrosecondsSinceDate
                                  .toString()
                                  .split(' ')
                                  .last
                                  .length -
                              0),
                  style: theme.largeTitleThin64.copyWith(fontSize: 96),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Passed on Miller\'s planet since Interstellar\'s release',
                  style: theme.largeTitle48,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),

            // const Spacer(),
            Column(
              children: [
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
                            Icons.arrow_downward_sharp,
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
          ],
        ),
      ),
    );
  }

  int microsecondsSinceData(DateTime startDate, DateTime endDate) {
    return startDate.difference(endDate).inMicroseconds;
  }

  double hoursInSevenYears() {
    return 7 * 365.25 * 24;
  }

  double microsecondeInSevenYears() {
    return 7 * 365.25 * 24 * 60 * 60 * 1000 * 1000;
  }

  DateTime formatMillersDateTimeSinceRelease(double millersHoursSinceDate) {
    final millersHours = millersHoursSinceDate.floor();
    final millersMinutes =
        ((millersHoursSinceDate - millersHours) * 60).floor();
    final millersSeconds =
        (((millersHoursSinceDate - millersHours) * 60 - millersMinutes) * 60)
            .round();
    final millersMilliseconds =
        ((((millersHoursSinceDate - millersHours) * 60 - millersMinutes) * 60 -
                    millersSeconds) *
                1000)
            .round();
    final millersMicroseconds =
        (((((millersHoursSinceDate - millersHours) * 60 - millersMinutes) * 60 -
                            millersSeconds) *
                        1000 -
                    millersMilliseconds) *
                1000)
            .round();
    // print('recalculation');

    return DateTime(2001, 1, 1, millersHours, millersMinutes, millersSeconds,
        millersMilliseconds, millersMicroseconds);
  }
}
