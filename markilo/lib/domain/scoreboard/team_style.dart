import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TeamStyle {
  const TeamStyle({
    required this.backgroundColor,
    required this.textColor,
    this.emblemFile,
  });

  final Color backgroundColor;
  final Color textColor;
  final PlatformFile? emblemFile;

  TeamStyle copyWith({
    Color? backgroundColor,
    Color? textColor,
    PlatformFile? emblemFile,
    bool clearEmblem = false,
  }) {
    return TeamStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      emblemFile: clearEmblem ? null : (emblemFile ?? this.emblemFile),
    );
  }
}
