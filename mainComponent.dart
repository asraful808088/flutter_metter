import 'dart:async';

import 'package:flutter/material.dart';
import './frames.dart';
import 'package:google_fonts/google_fonts.dart';

class MetterWidget extends StatefulWidget {
  final double progressValue;
  final double clockSize;
  final double fontSize;
  final Color hintColor;
  final Color textColor;
  final LinearGradient progressColor;
  final bool animationTransition;
  final String text;
  final int duration;
  MetterWidget(
      {Key? key,
      required this.progressValue,
      required this.clockSize,
      required this.fontSize,
      required this.hintColor,
      required this.progressColor,
      required this.textColor,
      required this.animationTransition,
      required this.text,
      required this.duration})
      : super(key: key);

  @override
  State<MetterWidget> createState() =>
      // ignore: no_logic_in_create_state
      _MetterWidgetState(
          duration: duration,
          text: text,
          animationTransition: animationTransition,
          progressValue: progressValue,
          clockSize: clockSize,
          hintColor: hintColor,
          fontSize: fontSize,
          textColor: textColor,
          progressColor: progressColor);
}

class _MetterWidgetState extends State<MetterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> progress;
  late Animation<double> _animationModify;
  late double progressValue;
  final double clockSize;
  final double fontSize;
  final Color hintColor;
  final Color textColor;
  final LinearGradient progressColor;
  final bool animationTransition;
  late String text;
  late double animationStopBeforeTime = 0;
  final int duration;
  @override
  void initState() {
    super.initState();
    if (animationTransition) {
      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: duration));
      _animationModify =
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
      progress =
          Tween<double>(begin: 0, end: progressValue).animate(_animationModify)
            ..addListener(() {
              setState(() {
                animationStopBeforeTime = progress.value;
              });
            });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant MetterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progressValue != widget.progressValue &&
        animationTransition) {
      properAnimation(animationValue: animationStopBeforeTime);
    } else {
      setState(() {
        progressValue = widget.progressValue;
      });
    }
    if (oldWidget.text != widget.text) {
      setState(() {
        text = widget.text;
      });
    }
  }

  _MetterWidgetState({
    required this.duration,
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.hintColor,
    required this.progressColor,
    required this.progressValue,
    required this.clockSize,
    required this.animationTransition,
  });
  @override
  Widget build(BuildContext context) {
    if (!animationTransition) {
      return metterComponents();
    } else {
      return AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) {
            return metterComponents();
          });
    }
  }

  void properAnimation({double? animationValue}) {
    progress = Tween<double>(begin: animationValue, end: widget.progressValue)
        .animate(_animationModify);
    _controller.reset();
    _controller.forward();
  }

  Widget metterComponents() {
    return SizedBox(
      height: clockSize,
      width: clockSize,
      child: CustomPaint(
        foregroundPainter: ClockFrames(
            progressValue: animationTransition ? progress.value : progressValue,
            progressBarColor: progressColor,
            hintColor: hintColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.anton(color: textColor, fontSize: fontSize),
            )
          ],
        ),
      ),
    );
  }
}
