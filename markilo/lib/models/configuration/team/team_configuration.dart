import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TeamConfiguration {
  final PlatformFile platformFile;
  final Color backgroundColor;
  final Color textColor;

  TeamConfiguration({
    required this.platformFile,
    required this.backgroundColor,
    required this.textColor,
  });

  // Método para serializar el objeto a un mapa de strings
  Map<String, String> toJson() {
    return {
      'logo': base64Encode(platformFile.bytes!),
      'backgroundColor': backgroundColor.value.toRadixString(16),
      'textColor': textColor.value.toRadixString(16),
    };
  }

  // Método para deserializar desde un mapa de strings
  static TeamConfiguration fromJson(Map<String, String> json) {
    return TeamConfiguration(
      platformFile: PlatformFile(
        name: 'team_logo.png',
        bytes: base64Decode(json['logo']!),
        size: base64Decode(json['logo']!).length,
      ),
      backgroundColor: Color(int.parse(json['backgroundColor']!, radix: 16)),
      textColor: Color(int.parse(json['textColor']!, radix: 16)),
    );
  }
}
