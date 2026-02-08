import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:markilo/domain/scoreboard/sport.dart';
import 'package:markilo/domain/scoreboard/team_side.dart';
import 'package:markilo/domain/scoreboard/team_style.dart';
import 'package:markilo/services/local_storage.dart';
import 'package:markilo/types/constants.dart';

/// Namespaced preferences per sport.
///
/// Keeps backward compatibility with the previous generic keys in [Constants].
class ScoreboardPrefs {
  ScoreboardPrefs(this.sport);

  final Sport sport;

  String _ns(String key) => '${sport.name}_$key';

  // ---- Score / Sets ----

  int readScore(TeamSide side) {
    final k = _ns(side == TeamSide.local ? 'score_local' : 'score_visit');
    final v = LocalStorage.prefs.getInt(k);
    if (v != null) return v;

    // Legacy fallback (shared keys)
    final legacy = LocalStorage.prefs.getInt(
      side == TeamSide.local ? Constants.scoreLeftValue : Constants.scoreRightValue,
    );
    return legacy ?? 0;
  }

  Future<void> writeScore(TeamSide side, int value) async {
    final k = _ns(side == TeamSide.local ? 'score_local' : 'score_visit');
    await LocalStorage.prefs.setInt(k, value);
  }

  int readSets(TeamSide side) {
    final k = _ns(side == TeamSide.local ? 'sets_local' : 'sets_visit');
    final v = LocalStorage.prefs.getInt(k);
    if (v != null) return v;

    // Legacy fallback
    final legacy = LocalStorage.prefs.getInt(
      side == TeamSide.local ? Constants.setLeftValue : Constants.setRightValue,
    );
    return legacy ?? 0;
  }

  Future<void> writeSets(TeamSide side, int value) async {
    final k = _ns(side == TeamSide.local ? 'sets_local' : 'sets_visit');
    await LocalStorage.prefs.setInt(k, value);
  }

  // ---- Names ----

  String? readTeamName(TeamSide side) {
    final k = _ns(side == TeamSide.local ? 'name_local' : 'name_visit');
    final v = LocalStorage.prefs.getString(k);
    if (v != null) return v;

    // Legacy fallback
    final legacy = LocalStorage.prefs.getString(
      side == TeamSide.local ? Constants.localTeamNameValue : Constants.visitTeamNameValue,
    );
    return legacy;
  }

  Future<void> writeTeamName(TeamSide side, String value) async {
    final k = _ns(side == TeamSide.local ? 'name_local' : 'name_visit');
    await LocalStorage.prefs.setString(k, value);
  }

  // ---- Orientation / serve ----

  bool readLocalOnLeft({bool defaultValue = true}) {
    final k = _ns('local_on_left');
    final v = LocalStorage.prefs.getBool(k);
    return v ?? defaultValue;
  }

  Future<void> writeLocalOnLeft(bool value) async {
    await LocalStorage.prefs.setBool(_ns('local_on_left'), value);
  }

  bool readLocalServe({bool defaultValue = true}) {
    final k = _ns('local_serve');
    final v = LocalStorage.prefs.getBool(k);
    return v ?? defaultValue;
  }

  Future<void> writeLocalServe(bool value) async {
    await LocalStorage.prefs.setBool(_ns('local_serve'), value);
  }

  // ---- Timeouts (2 circles) ----

  List<bool> readTimeouts(TeamSide side) {
    final k = _ns(side == TeamSide.local ? 'timeouts_local' : 'timeouts_visit');
    final mask = LocalStorage.prefs.getInt(k) ?? 0;
    return [
      (mask & 0x01) != 0,
      (mask & 0x02) != 0,
    ];
  }

  Future<void> writeTimeouts(TeamSide side, List<bool> timeouts) async {
    final k = _ns(side == TeamSide.local ? 'timeouts_local' : 'timeouts_visit');
    final mask = ((timeouts.isNotEmpty && timeouts[0]) ? 0x01 : 0) |
        ((timeouts.length > 1 && timeouts[1]) ? 0x02 : 0);
    await LocalStorage.prefs.setInt(k, mask);
  }

  // ---- Styles ----

  TeamStyle readStyle(TeamSide side, {required TeamStyle defaultStyle}) {
    final prefix = side == TeamSide.local ? 'team_local' : 'team_visit';

    final logoB64 = LocalStorage.prefs.getString(_ns('${prefix}_logo'));
    final bgStr = LocalStorage.prefs.getString(_ns('${prefix}_bg'));
    final textStr = LocalStorage.prefs.getString(_ns('${prefix}_text'));

    // Legacy fallback (shared keys)
    final legacyLogo = LocalStorage.prefs.getString(
      side == TeamSide.local ? Constants.teamLocalLogo : Constants.teamVisitLogo,
    );
    final legacyBg = LocalStorage.prefs.getString(
      side == TeamSide.local
          ? Constants.teamLocalBackgroundColor
          : Constants.teamVisitBackgroundColor,
    );
    final legacyText = LocalStorage.prefs.getString(
      side == TeamSide.local ? Constants.teamLocalTextColor : Constants.teamVisitTextColor,
    );

    final bg = bgStr ?? legacyBg;
    final text = textStr ?? legacyText;
    final logo = logoB64 ?? legacyLogo;

    Color backgroundColor = defaultStyle.backgroundColor;
    Color textColor = defaultStyle.textColor;
    PlatformFile? emblemFile = defaultStyle.emblemFile;

    if (bg != null) {
      try {
        backgroundColor = Color(int.parse(bg, radix: 16));
      } catch (_) {}
    }

    if (text != null) {
      try {
        textColor = Color(int.parse(text, radix: 16));
      } catch (_) {}
    }

    if (logo != null && logo.isNotEmpty) {
      try {
        final bytes = base64Decode(logo);
        emblemFile = PlatformFile(
          name: '${sport.name}_${side.name}_logo.png',
          bytes: bytes,
          size: bytes.length,
        );
      } catch (_) {}
    }

    return TeamStyle(
      backgroundColor: backgroundColor,
      textColor: textColor,
      emblemFile: emblemFile,
    );
  }

  Future<void> writeStyle(TeamSide side, TeamStyle style) async {
    final prefix = side == TeamSide.local ? 'team_local' : 'team_visit';

    await LocalStorage.prefs.setString(
      _ns('${prefix}_bg'),
      style.backgroundColor.value.toRadixString(16),
    );

    await LocalStorage.prefs.setString(
      _ns('${prefix}_text'),
      style.textColor.value.toRadixString(16),
    );

    // emblemFile is optional
    if (style.emblemFile?.bytes != null) {
      await LocalStorage.prefs.setString(
        _ns('${prefix}_logo'),
        base64Encode(style.emblemFile!.bytes!),
      );
    } else {
      await LocalStorage.prefs.remove(_ns('${prefix}_logo'));
    }
  }
}
