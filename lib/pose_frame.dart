import 'package:flutter/material.dart';

class PoseFrame {
  final Map<String, Offset> points;
  final Map<String, Color> pointColors;
  final String feedbackText;
  final IconData feedbackIcon;
  final Color feedbackColor;
  final bool isError;
  final int reps;

  PoseFrame({
    required this.points,
    required this.pointColors,
    required this.feedbackText,
    required this.feedbackIcon,
    required this.feedbackColor,
    required this.isError,
    required this.reps,
  });
}

